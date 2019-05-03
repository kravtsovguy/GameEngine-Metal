PROJECT_DIR=$(pwd)
PROJECT_NAME="GameEngine"
workspacePath="$PROJECT_DIR/$PROJECT_NAME.xcworkspace"
sharedSettings="$workspacePath/xcshareddata/WorkspaceSettings.xcsettings"
userSettings="$workspacePath/xcuserdata/$USER.xcuserdatad/WorkspaceSettings.xcsettings"
cp $sharedSettings $userSettings

