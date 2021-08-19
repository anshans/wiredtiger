cd test/checkpoint
CMD='nice ../../../test/checkpoint/recovery-test.sh WT_TEST.$t'
NPROCS=10
 
i=1
while true ; do
	echo "Iteration $((i++))"
	for((t=0; t<$NPROCS; t++)); do
		> nohup.out.$t ; eval nohup $CMD > nohup.out.$t 2>&1 &
	done
	for((t=0; t<$NPROCS; t++)); do
		wait -n || exit $?
	done
done

