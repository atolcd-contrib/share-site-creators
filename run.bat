::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::      Dev environment startup script for Alfresco Community     ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@ECHO OFF

SET COMPOSE_FILE_PATH=%CD%\target\classes\docker\docker-compose.yml

IF [%M2_HOME%]==[] (
    SET MVN_EXEC=mvn
)
ECHO MAVEN_OPTS is set to '%MAVEN_OPTS%'

IF NOT [%M2_HOME%]==[] (
    SET MVN_EXEC=%M2_HOME%\bin\mvn
)

IF [%1]==[] (
    echo "Usage: %0 {build_start|start|stop|purge|tail|reload_share|reload_acs}"
    GOTO END
)

IF %1==build_start (
    CALL :down
    CALL :build
    CALL :start
    CALL :tail
    GOTO END
)
IF %1==start (
    CALL :start
    CALL :tail
    GOTO END
)
IF %1==stop (
    CALL :down
    GOTO END
)
IF %1==restart (
    CALL :down
    CALL :start
    CALL :tail
    GOTO END
)
IF %1==reset (
    CALL :down
    CALL :purge
    CALL :build
    CALL :start
    CALL :tail
    GOTO END
)
IF %1==purge (
    CALL:down
    CALL:purge
    GOTO END
)
IF %1==tail (
    CALL :tail
    GOTO END
)
IF %1==reload_share (
    CALL :build_share
    CALL :start_share
    CALL :tail
    GOTO END
)
IF %1==reload_acs (
    CALL :build_acs
    CALL :start_acs
    CALL :tail
    GOTO END
)

echo "Usage: %0 {build_start|start|stop|restart|purge|reset|tail|reload_share|reload_acs}"
:END
EXIT /B %ERRORLEVEL%

:start
    docker volume create share-site-creators-acs-volume
    docker volume create share-site-creators-db-volume
    docker volume create share-site-creators-ass-volume
    docker-compose -f "%COMPOSE_FILE_PATH%" up --build -d
EXIT /B 0
:start_share
    docker-compose -f "%COMPOSE_FILE_PATH%" up --build -d share-site-creators-share
EXIT /B 0
:start_acs
    docker-compose -f "%COMPOSE_FILE_PATH%" up --build -d share-site-creators-acs
EXIT /B 0
:down
    if exist "%COMPOSE_FILE_PATH%" (
        docker-compose -f "%COMPOSE_FILE_PATH%" down
    )
EXIT /B 0
:build
	call %MVN_EXEC% clean package
EXIT /B 0
:build_share
    docker-compose -f "%COMPOSE_FILE_PATH%" kill share-site-creators-share
    docker-compose -f "%COMPOSE_FILE_PATH%" rm -f share-site-creators-share
	call %MVN_EXEC% clean package -pl share-site-creators-share,share-site-creators-share-docker
EXIT /B 0
:build_acs
    docker-compose -f "%COMPOSE_FILE_PATH%" kill share-site-creators-acs
    docker-compose -f "%COMPOSE_FILE_PATH%" rm -f share-site-creators-acs
	call %MVN_EXEC% clean package -pl share-site-creators-platform,share-site-creators-platform-docker
EXIT /B 0
:tail
    docker-compose -f "%COMPOSE_FILE_PATH%" logs -f
EXIT /B 0
:tail_all
    docker-compose -f "%COMPOSE_FILE_PATH%" logs --tail="all"
EXIT /B 0
:purge
    docker volume rm -f share-site-creators-acs-volume
    docker volume rm -f share-site-creators-db-volume
    docker volume rm -f share-site-creators-ass-volume
EXIT /B 0
