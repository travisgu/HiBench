#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

current_dir=`dirname "$0"`
root_dir=${current_dir}/../../../../../
workload_config=${root_dir}/conf/workloads/ml/kmeans.conf
. "${root_dir}/bin/functions/load-bench-config.sh"

enter_bench HadoopKmeans ${workload_config}
show_bannar start

ensure-mahout-release

rmr-hdfs $OUTPUT_HDFS || true

SIZE=`dir_size $INPUT_HDFS`
OPTION="-i ${INPUT_SAMPLE} -c ${INPUT_CLUSTER} -o ${OUTPUT_HDFS} -x ${MAX_ITERATION} -ow -cl -cd 0.5 -dm org.apache.mahout.common.distance.EuclideanDistanceMeasure -xm mapreduce"
CMD="${MAHOUT_HOME}/bin/mahout kmeans  ${OPTION}"
MONITOR_PID=`start-monitor`
START_TIME=`timestamp`
execute_withlog $CMD
END_TIME=`timestamp`
stop-monitor $MONITOR_PID

gen_report ${START_TIME} ${END_TIME} ${SIZE}
show_bannar finish
leave_bench
