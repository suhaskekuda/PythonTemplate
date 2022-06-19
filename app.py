from app_utils import *

log = putlog("MainExecutor")

configFile = "config/app.setting.json"
configuration = readJson(configFile)


if __name__ == "__main__":
    log.info("App Code")