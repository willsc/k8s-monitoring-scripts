#!/bin/bash

# Set the job and box names and other parameters
job_name="my_job"
job_command="my_command"
job_owner="my_username"
job_permission="gx,ge,wx,we,mx,me"
job_description="My job description"
box_name="my_box"
box_jobs="${job_name}"
box_owner="my_username"
box_permission="gx,ge,wx,we,mx,me"
box_description="My box description"

# Generate the job and box JIL file contents
cat <<EOF > "${box_name}.jil"
/* ----------------- BOX AND JOB DEFINITIONS ------------------ */

delete_job: ${job_name}
delete_box: ${box_name}

insert_job: ${job_name}
command: ${job_command}
owner: ${job_owner}
permission: ${job_permission}
description: "${job_description}"
condition: s("${box_name}")

insert_box: ${box_name}
owner: ${box_owner}
permission: ${box_permission}
description: "${box_description}"
box_success: ${box_jobs}

/* ----------------- BOX ASSIGNMENTS ------------------ */

${job_name}:

/* ----------------- END OF JOB FILE ------------------ */

/* ----------------- END OF BOX FILE ------------------ */
EOF

# Submit the JIL file to create the job and box, and delete the existing definitions
#jil < "${box_name}.jil"

