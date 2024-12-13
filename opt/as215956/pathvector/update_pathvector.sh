echo "# !!!         THIS FILE IS AUTOGENERATED BY AS215956 UPDATE SCRIPTS         !!!"
    echo "# !!!  DO NOT EDIT THIS FILE, CHANGES WILL BE OVERRIDEN ON NEXT GENERATION  !!!"
    echo "# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo " "
    echo " "
    echo " "
}

load_settings() {
    BIRD2_DIR="/etc/bird"
    DEFINITIONS_DIR="${BIRD2_DIR}/definitions"
    CURRENT_DATE=$(date +%d/%m/%Y)
    HEADER=$(created_by_header)
    if [[ ! -f "${APP_DIR}/general.conf" ]]; then
        echo "Error: general definitions file could not be found on this system"
        echo "       ${APP_DIR}/general.conf"
        exit 1
    fi
    . ${APP_DIR}/general.conf
}

check_bird_dirs() {
    echo -n " *** Checking bird directories:"
    if [[ ! -d "${DEFINITIONS_DIR}" ]]; then
        CMD=$(mkdir -p ${DEFINITIONS_DIR})
    fi
    echo " [DONE]"
}

check_log_file() {
    echo -n " *** Checking log file permissions:"
    if [[ ! -f "/var/log/pathvector.log" ]]; then
        CMD=$(touch /var/log/pathvector.log)
    fi
    CMD=$(chown bird:bird /var/log/pathvector.log)
    echo " [DONE]"

        echo -n " *** Checking log file permissions:"
    if [[ ! -f "/var/log/bird.log" ]]; then
        CMD=$(touch /var/log/bird.log)
    fi
    CMD=$(chown bird:bird /var/log/bird.log)
    echo " [DONE]"
}

create_general() {
    FILE="${DEFINITIONS_DIR}/general.conf"
    echo -n " *** Create general.conf:"
    echo "${HEADER}" > ${FILE}
    echo "define ROUTER_REGION_CODE = ${ROUTER_REGION_CODE};" >> ${FILE}
    echo "define ROUTER_COUNTRY_CODE = ${ROUTER_COUNTRY_CODE};" >> ${FILE}
    echo "define ROUTER_LOCATION_ID = ${ROUTER_LOCATION_ID};" >> ${FILE}
    echo "define ROUTER_ID = ${ROUTER_ID};" >> ${FILE}
    echo " [DONE]"
}

create_as_set() {
    TEMP_FILE="temp_update.sh"
    VARIABLE=${1}
    ASSET=${2}
    FILE="${DEFINITIONS_DIR}/${VARIABLE}.conf"
    echo -n " *** Loading AS-Set: ${ASSET}"
    CMD="/usr/bin/bgpq4 -S AFRINIC,APNIC,ARIN,LACNIC,RIPE -tb -l 'define ${VARIABLE}' ${ASSET}"
    echo "#!/bin/bash" > ${TEMP_FILE}
    echo "${CMD}" >> ${TEMP_FILE}
    RES=$(sh ${TEMP_FILE})
    echo "${HEADER}" > ${FILE}
    echo "# ${CMD}" >> ${FILE}
    echo "${RES}" >> ${FILE}
    CMD="rm -f ${TEMP_FILE}"
    echo " [DONE]"
}

create_ospf_range() {
    FILE="${DEFINITIONS_DIR}/MY_OSPF_RANGE.conf"
    ASN=$(echo "${AS_SET_ALL}" | tr ":" " " | awk {'print $1'})
    echo -n " *** Loading AS-Set: OSPF RANGE"
    CMD="/usr/bin/bgpq4 -S AFRINIC,APNIC,ARIN,LACNIC,RIPE -Ab6 -r 52 -R 128 -l 'define MY_OSPF_RANGE' ${ASN}"
    echo "#!/bin/bash" > temp_update.sh
    echo "${CMD}" >> temp_update.sh
    RES=$(sh temp_update.sh)
    echo "${HEADER}" > ${FILE}
    echo "# ${CMD}" >> ${FILE}
    echo "${RES}" >> ${FILE}
    CMD=$(rm -f temp_update.sh)
    echo " [DONE]"
}


create_as_set_all() {
    if [[ ! -z "${AS_SET_ALL}" ]]; then
        create_as_set "MY_AS_SET_ALL" "${AS_SET_ALL}"
    fi
}

create_as_set_downstream() {
    if [[ ! -z "${AS_SET_DOWNSTREAM}" ]]; then
        create_as_set "MY_AS_SET_DOWNSTREAM" "${AS_SET_DOWNSTREAM}"
    fi
}

create_as_set_upstream() {
    if [[ ! -z "${AS_SET_UPSTREAM}" ]]; then
        create_as_set "MY_AS_SET_UPSTREAM" "${AS_SET_UPSTREAM}"
    fi
}

run_pv() {
    CMD=$(/usr/bin/pathvector -t -v g)
}

main() {
    check_progs
    load_settings
    check_bird_dirs
    check_log_file
    create_general
    create_as_set_all
    create_as_set_downstream
    create_as_set_upstream
    create_ospf_range
    run_pv
}


# Options
while getopts "h-:H-:v-:V-:l-:L-:" option; do
    case ${option} in
        h|H)
            help
            exit
        ;;
        v|V)
            version
            exit
        ;;
        l|L)
            main >> /var/log/update_pathvector.log;
            exit
        ;;
        -) case $OPTARG in
                help|Help)
                    help
                    exit
                ;;
                version|Version)
                    version
                    exit
                ;;
                log|Log)
                    main >> /var/log/update_pathvector.log;
                    exit
                ;;
        esac;;
    esac
done

main
