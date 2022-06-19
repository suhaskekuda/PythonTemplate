#!/bin/bash

CURRENT_DIR=$(pwd)

if [[ ${CURRENT_DIR} == *bin ]];then
    CURRENT_DIR=$(dirname $CURRENT_DIR)
fi

REPORT_DIR="${CURRENT_DIR}/report"
REPORT="${REPORT_DIR}/codeSanity.log"

[! -f ${REPORT} ] && touch ${REPORT}
> ${REPORT}

CODE_VULNERABILITY(){
    echo "#############################" >> ${REPORT}
    echo "## Package Security Vulnerabilities " >> ${REPORT}
    echo "#############################" >> ${REPORT}
    safety check >> ${REPORT} 2>&1
    echo "#############################" >> ${REPORT}
    echo "#############################" >> ${REPORT}
    echo "" >> ${REPORT}

    echo "Package Security Vulnerabilities ... Done"
}

PROJECT_CODE_VULNERABILITY(){
    ALLPYTHON=$(find ${CURRENT_DIR} -type f -name "*.py" -not -path "${CURRENT_DIR}/venv/*" )
    echo "#############################" >> ${REPORT}
    echo "## Code Profiling and Standards  " >> ${REPORT}
    echo "#############################" >> ${REPORT}

    for CODEFILES in ${ALLPYTHON}; do
        echo -e "#### For : ${CODEFILES} ####\n" >> ${REPORT}
        bandit ${CODEFILES} >> ${REPORT} 2>&1
        echo -e "\n###########################\n" >> ${REPORT}
    done

    echo "#############################" >> ${REPORT}
    echo "#############################" >> ${REPORT}
    echo "" >> ${REPORT}

    echo "Code Profiling and Standards ... Done"
}

TESTSUIT(){
    pytest test/testSuit.py --excelreport=${REPORT_DIR}/testSuit_$(date +"%Y-%m-%d-%H%M%S").xls # > /dev/null 2>&1

    echo "Test Suit ... Done"
}

MAIN(){

    [ ! -d ${REPORT_DIR} ] && mkdir -p ${REPORT_DIR}
    CODE_VULNERABILITY
    PROJECT_CODE_VULNERABILITY
    TESTSUIT

    echo -e "\n Reports can be fond at ${REPORT_DIR}"
}

MAIN $*