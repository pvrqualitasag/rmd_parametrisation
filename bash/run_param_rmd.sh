#!/bin/bash
#' ---
#' title: Run Parametrized Rmd
#' date:  2020-04-21 09:27:04
#' author: Peter von Rohr
#' ---
#' ## Purpose
#' Demonstrate the use of parametrized Rmarkdown documents. {Write a paragraph about what problems are solved with this script.}
#'
#' ## Description
#' Run parametrized rmd {Write a paragraph about how the problems are solved.}
#'
#' ## Details
#' Rmarkdown documents can depend on external parameters. This script shows how the parameters are passed to the document. {Give some more details here.}
#'
#' ## Example
#' ./run_param_rmd.sh {Specify an example call of the script.}
#'
#' ## Set Directives
#' General behavior of the script is driven by the following settings
#+ bash-env-setting, eval=FALSE
set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
                  #  hence pipe fails if one command in pipe fails


#' ## Global Constants
#' ### Paths to shell tools
#+ shell-tools, eval=FALSE
ECHO=/bin/echo                             # PATH to echo                            #
DATE=/bin/date                             # PATH to date                            #
BASENAME=/usr/bin/basename                 # PATH to basename function               #
DIRNAME=/usr/bin/dirname                   # PATH to dirname function                #

#' ### Directories
#' Installation directory of this script
#+ script-directories, eval=FALSE
INSTALLDIR=`$DIRNAME ${BASH_SOURCE[0]}`    # installation dir of bashtools on host   #

#' ### Files
#' This section stores the name of this script and the
#' hostname in a variable. Both variables are important for logfiles to be able to
#' trace back which output was produced by which script and on which server.
#+ script-files, eval=FALSE
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`       # Set Script Name variable                #
SERVER=`hostname`                          # put hostname of server in variable      #



#' ## Functions
#' The following definitions of general purpose functions are local to this script.
#'
#' ### Usage Message
#' Usage message giving help on how to use the script.
#+ usg-msg-fun, eval=FALSE
usage () {
  local l_MSG=$1
  $ECHO "Usage Error: $l_MSG"
  $ECHO "Usage: $SCRIPT -a <a_example> -b <b_example> -c"
  $ECHO "  where -a <a_example> ..."
  $ECHO "        -b <b_example> (optional) ..."
  $ECHO "        -c (optional) ..."
  $ECHO ""
  exit 1
}

#' ### Start Message
#' The following function produces a start message showing the time
#' when the script started and on which server it was started.
#+ start-msg-fun, eval=FALSE
start_msg () {
  $ECHO "********************************************************************************"
  $ECHO "Starting $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
  $ECHO "Server:  $SERVER"
  $ECHO
}

#' ### End Message
#' This function produces a message denoting the end of the script including
#' the time when the script ended. This is important to check whether a script
#' did run successfully to its end.
#+ end-msg-fun, eval=FALSE
end_msg () {
  $ECHO
  $ECHO "End of $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
  $ECHO "********************************************************************************"
}

#' ### Log Message
#' Log messages formatted similarly to log4r are produced.
#+ log-msg-fun, eval=FALSE
log_msg () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_RIGHTNOW=`$DATE +"%Y%m%d%H%M%S"`
  $ECHO "[${l_RIGHTNOW} -- ${l_CALLER}] $l_MSG"
}


#' ## Main Body of Script
#' The main body of the script starts here.
#+ start-msg, eval=FALSE
start_msg


#' ## Set evaluation directory
#+ set-eval-dir
EVALDIR=`$DIRNAME $INSTALLDIR`
cd $EVALDIR

#' ## Prepare Data
#' In a first step the data is prepared.
#+ prepare-data
(echo "s_data_path <- '$EVALDIR/data/meat.csv'";cat $EVALDIR/R/data_sim.R) | R --no-save


#' ## Render the Rmd
#' The Rmarkdown document is rendered by passing the path to the data file as a parameter.
#+ render-rmd
R -e "rmarkdown::render('$EVALDIR/rmd/box_plot.Rmd', params = list(data = '$EVALDIR/data/meat.csv'))"


#' ## End of Script
#+ end-msg, eval=FALSE
end_msg

