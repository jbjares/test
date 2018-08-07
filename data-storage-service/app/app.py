from flask import Flask, send_from_directory
import os
import sys

FILENAME_KEY = "PHT_DATA_STORAGE_FILENAME"
STATION_NAME_KEY = "PHT_DATA_STORAGE_NAME"

#######
GET_ONLY = ['GET']
#######

class ConfigurationException(Exception):
    """Exception raised when the initial configuration of the flask app fails

    Attributes:
        message -- explanation of the error
    """

    def __init__(self, message):
        self.message = message


def get_data_dir():
    return os.path.join(app.root_path, "data")


def file_exists(filename: str):
    """
    Checks whether the provided filename is part of the data dir

    :param filename: Which filename to check
    :return:
    """
    return filename in os.listdir(get_data_dir())


def config_exception_if(test: bool, message: str):
    if test:
        raise ConfigurationException(message)


def value_from_env(key):
    config_exception_if(key not in os.environ, "Config Key: {} missing in environment".format(key))
    return os.environ[key]


def filename_from_env():

    filename_value = value_from_env(FILENAME_KEY)
    config_exception_if(not file_exists(filename_value), "File does not exist: {}".format(filename_value))
    return filename_value


def stationname_from_env():
    return value_from_env(STATION_NAME_KEY)


def test_config():
    filename_from_env()
    stationname_from_env()
#####################################################################################################


app = Flask(__name__)


@app.route('/data', methods=GET_ONLY)
def data():
    return send_from_directory(directory=get_data_dir(), filename=filename_from_env())


@app.route('/name', methods=GET_ONLY)
def name():
    return stationname_from_env() + os.linesep


if __name__ == '__main__':

    # Startup tests
    try:
        test_config()
    except ConfigurationException as e:
        print("FATAL: " + e.message)
        sys.exit(1)

    app.run(host='0.0.0.0', port=5000)

