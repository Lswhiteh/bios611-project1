import os
import shutil
from glob import glob
import csv

from sklearn.model_selection import train_test_split
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint, ReduceLROnPlateau
from tensorflow.keras.layers import (
    BatchNormalization,
    Conv2D,
    Dense,
    Input,
    MaxPooling2D,
)
from tensorflow.keras.models import Model
from tensorflow.keras.preprocessing.image import ImageDataGenerator

import plotting_utils as pu


def prep_dirs(base_dir, working_dir):
    """
    Creates train/val dirs inside base directory that contain each class \
        and test dir for test samples.

    Args:
        base_dir (str): Base directory with mushroom species subdirs.
        working_dir (str): Directory to add new subdirs to for working.
    """
    high_level_dirs = glob(base_dir + "/*")

    for dir in high_level_dirs:
        if not os.path.exists(
            os.path.join(working_dir, "train", os.path.split(dir)[-1])
        ):
            os.makedirs(os.path.join(working_dir, "train", os.path.split(dir)[-1]))
            os.makedirs(os.path.join(working_dir, "val", os.path.split(dir)[-1]))

    if not os.path.exists(os.path.join(working_dir, "test")):
        os.makedirs(os.path.join(working_dir, "test"))


def split_dir_samples(base_dir, working_dir):
    """
    Splits data into train/val/test and copies into respective \
        subidrs for each species.

    Args:
        base_dir (str): Base directory with mushroom species subdirs.
        working_dir (str): Directory to add new subdirs to for working.

    """
    for class_dir in glob(base_dir + "/*"):
        print(class_dir)
        raw_files = glob(class_dir + "/*")
        # print(raw_files)
        X_train, X_val = train_test_split(raw_files, test_size=0.3)
        X_val, X_test = train_test_split(X_val, test_size=0.5)

        for train_file in X_train:
            shutil.copy(
                train_file,
                os.path.join(
                    working_dir,
                    "train",
                    os.path.split(class_dir)[-1],
                    os.path.split(train_file)[-1],
                ),
            )
        for val_file in X_val:
            shutil.copy(
                val_file,
                os.path.join(
                    working_dir,
                    "val",
                    os.path.split(class_dir)[-1],
                    os.path.split(val_file)[-1],
                ),
            )
        for test_file in X_test:
            shutil.copy(
                test_file,
                os.path.join(working_dir, "test", os.path.split(test_file)[-1]),
            )


def create_image_generators(base_dir):
    """
    Creates ImageDataGenerators using flow_from_directory for \
        each partition of image data.

    Args:
        base_dir (str): Base directory with mushroom species subdirs.

    Returns:
        [ImageDataGenerators]: Train, val, test data generators \
            to use when fitting model.
    """
    train_datagen = ImageDataGenerator(
        rescale=1.0 / 255, shear_range=0.2, zoom_range=0.2, horizontal_flip=True
    )
    val_datagen = ImageDataGenerator(
        rescale=1.0 / 255, shear_range=0.2, zoom_range=0.2, horizontal_flip=True
    )
    test_datagen = ImageDataGenerator(rescale=1.0 / 255)

    train_gen = train_datagen.flow_from_directory(
        directory=os.path.join(base_dir, "train"),
        target_size=(255, 255),
        color_mode="rgb",
        class_mode="categorical",
        shuffle=True,
        seed=42,
    )

    val_gen = val_datagen.flow_from_directory(
        directory=os.path.join(base_dir, "val"),
        target_size=(255, 255),
        color_mode="rgb",
        class_mode="categorical",
        shuffle=True,
        seed=42,
    )

    test_gen = test_datagen.flow_from_directory(
        directory=os.path.join(base_dir, "test"),
        target_size=(255, 255),
        color_mode="rgb",
        batch_size=1,
        class_mode="categorical",
        shuffle=False,
        seed=42,
    )

    return [train_gen, val_gen, test_gen]


def create_model():
    """
    Creates basic 3-block CNN with softmax-activate Dense layer for output.

    Returns:
        Keras model: Compiled keras CNN model.
    """
    in_layer = Input((255, 255, 3))

    conv_block_1 = Conv2D(128, 3, activation="relu")(in_layer)
    conv_block_1 = MaxPooling2D((2, 2))(conv_block_1)
    conv_block_1 = BatchNormalization()(conv_block_1)

    conv_block_2 = Conv2D(64, 3, activation="relu")(conv_block_1)
    conv_block_2 = MaxPooling2D((2, 2))(conv_block_2)
    conv_block_2 = BatchNormalization()(conv_block_2)

    conv_block_3 = Conv2D(32, 3, activation="relu")(conv_block_2)
    conv_block_3 = MaxPooling2D((2, 2))(conv_block_3)
    conv_block_3 = BatchNormalization()(conv_block_3)

    dense_block = Dense(128, activation="relu")(conv_block_3)
    dense_block = Dense(9, activation="softmax")(dense_block)

    cnn_model = Model(inputs=in_layer, outputs=dense_block, name="Mushroom CNN")

    cnn_model.compile(
        loss="categorical_crossentropy", optimizer="adam", metrics=["accuracy"]
    )

    return cnn_model


def create_callbacks(base_dir):
    """
    Creates and returns callbacks for earlystopping and checkpointing.

    Args:
        base_dir (str): Base directory with mushroom species subdirs.

    Returns:
        [callbacks]: List of EarlyStopping, ModelCheckpoint, \
            and LR reduction callbacks.
    """
    # Stop model early if acc stops increasing.
    callback = EarlyStopping(
        monitor="val_accuracy", patience=10, restore_best_weights=True
    )

    # Save model when new best is found.
    checkpoint = ModelCheckpoint(
        filepath=os.path.join(base_dir, "Mushrooms.model"),
        save_best_only=True,
        monitor="val_accuracy",
        mode="max",
    )

    # Reduce learning rate if performance doesn't increase.
    reduce_lr = ReduceLROnPlateau(
        monitor="loss", factor=0.5, patience=10, min_lr=0.0001
    )

    callbacks = [reduce_lr, checkpoint, callback]

    return callbacks


def train_model(model, generators, callbacks):
    """
    Fits model using image generators with appropriate callbacks.

    Args:
        model (Keras Model): CNN Model
        generators ([ImageDataGenerators]): List of train/val/test generators \
            for streaming in images.
        callbacks ([Keras callbacks]): List of Keras Callback functions \
            for model utility during training.

    Returns:
        Keras Model: Trained Keras model on image data.
        History: Keras history of trained model, used for plotting.
    """
    train_gen, val_gen, _ = generators
    print(model.summary())

    history = model.fit(
        training_data=train_gen,
        validation_data=val_gen,
        steps_per_epoch=train_gen.n // 32,
        validation_steps=val_gen.n // 32,
        epochs=40,
        callbacks=callbacks,
    )

    score = model.evaluate(val_gen)
    print("Evaluation loss:", score[0])
    print("Evaluation accuracy:", score[1])

    return model, history


def test_model(model, generators, base_dir):
    """
    Tests model on unseen data and plots accuracy metrics.
    Writes true values and predicted values to file.

    Args:
        model (Keras Model): Trained Keras Model.
        generators ([ImageDataGenerators]): List of streaming generators.
        base_dir (str): Base directory with mushroom species subdirs.
    """
    _, _, test_gen = generators
    predictions = model.predict(test_gen)
    preds = predictions.argmax(axis=-1)
    true_labs = test_gen.class_indices

    conf_mat = pu.print_confusion_matrix(true_labs, preds)
    mush_list = [
        "Agaricus",
        "Amanita",
        "Boletus",
        "Entoloma",
        "Hygrocybe",
        "Lactarius",
        "Russula",
        "Suillus",
    ]
    pu.plot_confusion_matrix(base_dir, conf_mat, mush_list, "Mushroom CNN")

    pu.print_classification_report(true_labs, preds)

    with open("model_predictions.csv", "w") as outfile:
        writ = csv.writer(outfile)
        for i, j in zip(true_labs, preds):
            writ.writerow((i, j))


