import os
import shutil
from glob import glob

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

