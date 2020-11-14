import os
import shutil
from glob import glob
import csv

from PIL import ImageFile

ImageFile.LOAD_TRUNCATED_IMAGES = True

from sklearn.model_selection import train_test_split
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint, ReduceLROnPlateau
from tensorflow.keras.layers import (
    BatchNormalization,
    Conv2D,
    Dense,
    Input,
    Flatten,
    MaxPooling2D,
    Dropout,
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
            os.makedirs(os.path.join(working_dir, "test", os.path.split(dir)[-1]))


def split_dir_samples(base_dir, working_dir):
    """
    Splits data into train/val/test and copies into respective \
        subidrs for each species.

    Args:
        base_dir (str): Base directory with mushroom species subdirs.
        working_dir (str): Directory to add new subdirs to for working.

    """
    for class_dir in glob(base_dir + "/*"):
        raw_files = glob(class_dir + "/*")
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
                os.path.join(
                    working_dir,
                    "test",
                    os.path.split(class_dir)[-1],
                    os.path.split(test_file)[-1],
                ),
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
        rescale=1.0 / 100, shear_range=0.2, zoom_range=0.2, horizontal_flip=True
    )
    val_datagen = ImageDataGenerator(
        rescale=1.0 / 100, shear_range=0.2, zoom_range=0.2, horizontal_flip=True
    )
    test_datagen = ImageDataGenerator(rescale=1.0 / 100)

    train_gen = train_datagen.flow_from_directory(
        directory=os.path.join(base_dir, "train"),
        target_size=(100, 100),
        color_mode="rgb",
        class_mode="categorical",
        shuffle=True,
        seed=42,
    )

    val_gen = val_datagen.flow_from_directory(
        directory=os.path.join(base_dir, "val"),
        target_size=(100, 100),
        color_mode="rgb",
        class_mode="categorical",
        shuffle=True,
        seed=42,
    )

    test_gen = test_datagen.flow_from_directory(
        directory=os.path.join(base_dir, "test"),
        target_size=(100, 100),
        color_mode="rgb",
        class_mode="categorical",
        batch_size=1,
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
    in_layer = Input((100, 100, 3))

    # Taking this out for now, don't want to set up GPU
    # conv_block_1 = Conv2D(128, 3, activation="relu")(in_layer)
    # conv_block_1 = MaxPooling2D((2, 2))(conv_block_1)
    # conv_block_1 = BatchNormalization()(conv_block_1)

    # conv_block_2 = Conv2D(64, 3, activation="relu")(in_layer)
    # conv_block_2 = MaxPooling2D((2, 2))(conv_block_2)
    # conv_block_2 = BatchNormalization()(conv_block_2)

    conv_block_3 = Conv2D(32, 3, activation="relu")(in_layer)
    conv_block_3 = MaxPooling2D((2, 2))(conv_block_3)
    conv_block_3 = BatchNormalization()(conv_block_3)

    flat = Flatten()(conv_block_3)

    dense_block = Dense(128, activation="relu")(flat)
    dense_block = Dropout(0.3)(dense_block)
    dense_block = Dense(9, activation="softmax")(dense_block)

    cnn_model = Model(inputs=in_layer, outputs=dense_block, name="Mushroom_CNN")

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
        train_gen,
        validation_data=val_gen,
        epochs=40,
        callbacks=callbacks,
        batch_size=32,
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
    _1, _2, test_gen = generators
    mush_dict = {v: k for k, v in test_gen.class_indices.items()}

    predictions = model.predict(test_gen)
    preds = predictions.argmax(axis=-1)

    true_labs = test_gen.labels
    genus_labs = [mush_dict[i] for i in true_labs]

    conf_mat = pu.print_confusion_matrix(true_labs, preds)

    pu.plot_confusion_matrix(
        base_dir, conf_mat, list(mush_dict.values()), "Mushroom CNN"
    )

    pu.print_classification_report(true_labs, preds)

    with open("model_predictions.csv", "w") as outfile:
        writ = csv.writer(outfile)
        for i, j, k in zip(genus_labs, true_labs, preds):
            writ.writerow((i, j, k))


def main():
    source_dir = "source_data/Mushrooms"
    working_dir = "derived_data/Mushrooms"

    if not os.path.exists(os.path.join(working_dir, "train")):
        prep_dirs(source_dir, working_dir)
        split_dir_samples(source_dir, working_dir)

    generators = create_image_generators(working_dir)

    if not os.path.exists(os.path.join(working_dir, "Mushrooms.model")):
        callbacks = create_callbacks(working_dir)
        model = create_model()

        trained_model, history = train_model(model, generators, callbacks)
        pu.plot_training(working_dir, history, "Mushrooms CNN")

    else:
        trained_model = load_model(os.path.join(working_dir, "Mushrooms.model"))

    test_model(trained_model, generators, working_dir)


if __name__ == "__main__":
    main()