#!/bin/bash -e

# This file downloads the LibriSpeech ASR corpus from OpenSLR

DS2_ROOT=$(cd $(dirname $0)/.. && pwd)

if [[ -z "$1" ]]
then
	echo "Usage: ./download-librispeech.sh [train-clean-100|train-clean-360|train-other-500]"
	exit -1
fi

DATASET=$1

# Download dataset
rm -rf LibriSpeech

if [ ! -f $DATASET.tar.gz ]; then
	wget http://www.openslr.org/resources/12/$DATASET.tar.gz
fi

if [ ! -f dev-clean.tar.gz ]; then
	wget http://www.openslr.org/resources/12/dev-clean.tar.gz
fi

if [ ! -f test-clean.tar.gz ]; then
	wget http://www.openslr.org/resources/12/test-clean.tar.gz
fi

tar -xvzf $DATASET.tar.gz
tar -xvzf dev-clean.tar.gz
tar -xvzf test-clean.tar.gz

# Convert to .wav
find . -iname "*.flac" | wc
for flacfile in `find . -iname "*.flac"`
do
    sox "${flacfile%.*}.flac" -e signed -b 16 -c 1 -r 16000 "${flacfile%.*}.wav"
done

# Construct JSON
python $DS2_ROOT/dataset/create_desc_json.py $DS2_ROOT/dataset/LibriSpeech/$DATASET corpus-train.json
python $DS2_ROOT/dataset/create_desc_json.py $DS2_ROOT/dataset/LibriSpeech/dev-clean corpus-val.json
python $DS2_ROOT/dataset/create_desc_json.py $DS2_ROOT/dataset/LibriSpeech/test-clean corpus-test.json
