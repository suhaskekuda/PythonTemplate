#!/bin/bash

CURRENT_DIR=$(pwd)

if [[ ${CURRENT_DIR} == *bin ]];then
    CURRENT_DIR=$(dirname $CURRENT_DIR)
fi

PYTHON="python3.9"

VENV="${CURRENT_DIR}/venv"
LOG_DIR="${CURRENT_DIR}/logs"
LOG_FILE="${LOG_DIR}/setup.log"
CONFIG_FILE="${CURRENT_DIR}/config/app.setting.json"

PYTHONCACHE="${CURRENT_DIR}/__pycache__"

LOG() 
{
    echo "[`date`] - ${*}" | tee -a ${LOG_FILE}
}

SETUP_PLAYGROUND(){
    FAILED_INSTALLATION=0    

    LOG "Seting up workplace ... Initiated"
    CLEAN_PLAYGROUND
    
    ${PYTHON} -m venv ${VENV}
    [ $? == 0 ] && LOG "Created environment ... Success" || LOG "Created environment ... Failed"

    source ${VENV}/bin/activate
    [ $VIRTUAL_ENV != "" ] && LOG "Inside Virtual environement ... $VIRTUAL_ENV" || exit 1

    pip install --upgrade pip > /dev/null 2>&1 
    
    RET=$?
    if [ "x${RET}" == "x0" ];then 
        LOG "Upgraded PIP ... Done"
    else
        FAILED_INSTALLATION=1 
        LOG "Upgraded PIP ... Failed"    
    fi
    
    pip install -r requirements.txt > /dev/null 2>&1 
    
    RET=$?
    if [ "x${RET}" == "x0" ];then 
        LOG "Install package ... Done"
    else
        FAILED_INSTALLATION=1 
        LOG "Install package ... Failed"    
    fi
    
    deactivate

    cp -p ${CONFIG_FILE} ${CONFIG_FILE}.orig

    if [ "x${FAILED_INSTALLATION}" == "x0" ];then
        LOG "Seting up workplace ... Completed"
        LOG "To begin working, use the following command to enable the virtual environment: source venv/bin/activate."
    else
        LOG "Seting up workplace ... Failed"
    fi

    return 0

}

GIT_PUSH() {

    #git add .
    read -p "Add comment for this commit : " COMMENT
    git commit -a -m "${COMMENT}"
    git push
    
}

CLEAN_PLAYGROUND(){
    
    LOG "Cleaning workplace ... Initiated"

    [ "x$VIRTUAL_ENV" != "x" ] && 
    LOG "You are inside virtual environment !! Please come out of virtual environment and try again" && 
    LOG "Command for coming out virtual environment : deactivate" && 
    exit 1

    [ -d ${VENV} ] && rm -rf ${VENV}
    [ -d ${LOG_DIR} ] && rm -rf ${LOG_DIR}/*
    [ -d ${PYTHONCACHE} ] && rm -rf ${PYTHONCACHE}
    LOG "Cleaning workplace ... Completed"

    return
}


HELP(){
cat <<EOF

  Usage : $0 Option

  Option :  setup -- Create playground
            clean -- Clean playground
            push "<message>" -- git push

EOF
}

MAIN(){

    case $1 in
	setup)
		SETUP_PLAYGROUND
		;;
	clean)
		CLEAN_PLAYGROUND
		;;
    push)
        GIT_PUSH
        ;;
    help)
		HELP
		;;
	*)
		HELP
		;;
    esac
    
}

MAIN $*

