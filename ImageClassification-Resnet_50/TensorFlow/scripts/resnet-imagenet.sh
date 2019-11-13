DATASET_DIR=/docker_home/datasets/imagenet/tensorflow
ROC_INDIR=/docker_home/tbd-suite/rocprof_input
TRAIN_DIR=./log

if [ "$1" = "" ]
then
        PREFIX=
        SUFFIX=

elif [ "$1" = "--profile" ]
then
        mkdir -p measurements
#        PREFIX="/usr/local/cuda/bin/nvprof --profile-from-start off \
#                --export-profile measurements/resnet50-tensorflow.nvvp -f --print-summary"
#        SUFFIX=" --nvprof_on=True"
        PREFIX="rocprof -i $ROC_INDIR/util.txt"
        SUFFIX=""
else
        echo "Invalid input argument. Valid ones are --profile."; exit -1
fi

$PREFIX python3 ../source/train_image_classifier.py --train_dir=$TRAIN_DIR --dataset_dir=$DATASET_DIR \
	--model_name=resnet_v2_50 --optimizer=sgd --batch_size=32 \
	--learning_rate=0.1 --learning_rate_decay_factor=0.1 --num_epochs_per_decay=30 \
	--weight_decay=0.0001 $SUFFIX

