jupyter lab \
--NotebookApp.ip=0.0.0.0 \
--NotebookApp.token=${NOTEBOOK_TOKEN} \
--NotebookApp.iopub_msg_rate_limit=10000 \
--FileManagerMixin.use_atomic_writing=False
