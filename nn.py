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

