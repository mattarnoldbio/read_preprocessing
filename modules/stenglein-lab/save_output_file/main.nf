/*
  This is just a dummy process to enable saving of output files         
  that aren't otherwise output.  For instance, files created by
  collectFile() in a workflow context.
 */
process SAVE_OUTPUT_FILE {
    tag "$file_to_save"
    label 'process_low'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    'oras://community.wave.seqera.io/library/coreutils:9.12--34be2b55ff8e6687' :
    'community.wave.seqera.io/library/coreutils:9.12--83081953909e2904' }"

    input:
    path(file_to_save, stageAs: "input/*")

    output:
    path("*", includeInputs: true) 

    when:
    task.ext.when == null || task.ext.when

    script:
    def args       = task.ext.args ?: ''
	 def link_name  = file_to_save.fileName.name
    """
    # force a hard link with ln -L
    ln -L $file_to_save $link_name
    """

}
