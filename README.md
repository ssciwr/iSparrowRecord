[![tests](https://github.com/ssciwr/iSparrowRecord/actions/workflows/main.yml/badge.svg?event=push)](https://github.com/ssciwr/iSparrowRecord/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/ssciwr/iSparrowRecord/graph/badge.svg?token=FwyE0PNiOk)](https://codecov.io/gh/ssciwr/iSparrowRecord)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ssciwr_iSparrowRecord&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=ssciwr_iSparrowRecord)
[![Supported OS: Linux](https://img.shields.io/badge/OS-Linux%20%7C%20macOS%20%7C%20Windows-green.svg)](https://www.linux.org/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# faunanet-record - Audio Recording facilities for the faunanet package
The `faunanet-record` project is a simple collection of audio recording facilities for the [faunanet](https://github.com/ssciwr/iSparrow) project. While it can be used standalone, it is designed to cooperate with `faunanet`. 

# Installation
faunanet-record officially only supports Linux-based operating systems and tests on Ubuntu. That being said, it has been successfully deployed on macOS, too. However, it has never been tried on Windows. the following assumes an Ubuntu installation: 

- Install portaudio and gcc (should already be there) first. `faunanet-record` depends on pyaudio, which in turn depends on portaudio. Hence, these steps are essential. 
```bash 
sudo apt install portaudio19-dev gcc
```

- Then, to get the newest release, install `faunanet-record` via pip: 
```bash 
python3.x -m pip install faunanet-record
```
After this, you should be able to get the `faunanet-record` cli in a terminal window by typing `faunanet-record`. 
Replace the `x` with the python version you want `faunanet-record` to run on, or leave it out and use `python3` only if you want your OS' default python version. `faunanet-record` has been tested on `python3.9` and `python3.12`.

You might want to have a [virtual environment](https://docs.python.org/3/library/venv.html) to install `faunanet-record` into to not pollute the global system namespace.

For a development installation, install `faunanet-record` in editable mode: 

- Clone this repository
```bash
 git clone https://github.com/ssciwr/iSparrowRecord.git 
```
or, when you're using ssh: 
```bash
git@github.com:ssciwr/iSparrowRecord.git
```

- then, from the root directory of the repository: 
```bash 
python3 -m pip install -e .[dev,doc]
```

# Usage
Before being able to run `faunanet-record`, an environment must be set up that provides folders to read configuration files from and to put recorded audio files to. 
This is done with the command (assuming `faunanet_record` is in you `PATH`): 
```bash
faunanet_record install --cfg_dir=/path/to/cfgdir
```
`--cfg_dir` is an optional argument that must contain two configuration files: `install.yml` and `default.yml`. These provide information about how to set up `faunanet_record` (`install.yml`) and a set of default parameters with which to run it (`default.yml`).
`faunanet-record` uses the yaml format to provide configuration files for its setup and usage. If you don't pass the `--cfg_dir` argument, the defaults `faunanet_record` comes with will be used. 

### Default configuration files 
The content of these files is as follows:

- `install.yml` only provides a folder for putting data files into at the moment: 
```yaml
Directories: 
  data: ~/faunanet_data
```
- `default.yml` provides all the parameters a run needs: 
``` yaml
Output: 
  output_folder:  ~/faunanet_data
  runtime: 9 
  data_folder_suffix: ""
  dump_config: True
Recording:
  sample_rate: 48000
  length_s: 3
  channels: 1
```
In order to customize them, make a folder `faunanet_install` and put files `install.yml` and `default.yml` in it. Then copy the above content into the respective files and customize them 
to your liking. `install.yml` will determine an output folder to be made, and `default.yml` will provide default parameters `faunanet-record` is run with when you do not pass a separate config file (see below).
In the following the meaning of the parameters will be explained. 

### Configuration parameters 
- In the install config file, the `data` entry sets the folder where `faunanet-record should put recorded audio data to. Can be everywhere you have write permission for. 

- In the parameter config file, keys have the following meaning: 
  - **output_folder**: The folder to put data to. Per default this should be identical to the `data` folder given in the `install.yml`. 
  - **runtime**: How long you want to record data in total. Can be: 
    - an integer that gives a duration in seconds 
    - a date given in the format: "%Y-%m-%d_%H:%M:%S", e.g., 2024-04-04_12:05:00
    - a string reading "inf": then, the recording will run indefinitely
  - **data_folder_suffix**: Each `faunanet_record` session puts its data into a subfolder of **output_folder**. These will always contain a timestamp of the format that **runtime** accepts, plus a suffix given by this parameter. Can be any string.
  - **dump_config**: Wether to write out the set of parameters with which a recording session has been run into the **output_folder**/current_run. Can be [True, False]
  - **sample_rate**: The sample rate for recordings. Usually determined by the microphone you use. 
  - **lenth_s**: lenght of each recorded audio file in seconds. 
  - **channesls**: How many channels to use for recording. Determined by the microphone.


## Running `faunanet-record` 
After installation and setup, you can run `faunanet-record` from the terminal (assuming again it's accessible from you `PATH`): 
```bash 
faunanet_record run
```
This will run `faunanet-record` with the default parameters defined above. If you want to run a session with customized paramters, you can use the same approach as before: 
- write your custom config yaml file and save it at a convenient location, for instance at `~faunanet_configs/record_config.yml`. 
- 
- pass it to the `run` command: 
```bash 
faunanet_record run --cfg=~faunanet_configs/record_config.yml 
``` 
You only have to include the parameters that you want to override in the custom config, but you must adhere to the hierarchy of the file. See the example below: 
```yaml
Output:
  runtime: inf
  dump_config: True
  data_folder_suffix: "_test"
Recording:
  sample_rate: 32000
  length_s: 30
```
## Using `faunanet-record` as a library 
You can use `faunanet-record` in your own project by importing it: 
```python 
import faunanet_record as faunr 
```
which exposes the `Runner` and `Recorder` classes per default. See the [docs](https://isparrowrecord.readthedocs.io/en/latest/) for documentation of available methods and classes.


## `faunanet-record` and docker
tbd