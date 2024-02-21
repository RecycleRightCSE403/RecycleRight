# This script is not meant to be run locally. It should be run on an AWS EC2
# instance, where it will clone the commit set as DEPLOY_SHA env var and set up
# whatever is needed to start the backend server

# run it on a remote server with this command structure:
# ssh ubuntu@<aws-hostname> DEPLOY_SHA="..." ROBOFLOW_API_KEY="..." ... 'bash -s' < deploy_ec2.sh

# env vars:
# DEPLOY_TAG = branch or tag name to deploy
# ROBOFLOW_API_KEY
# GEMINI_API_KEY

# assumes python3, nginx are installed and configured

# remove old version
rm -r RecycleRight

# clone new version
git clone https://github.com/RecycleRightCSE403/RecycleRight.git
cd RecycleRight/
git reset --hard $DEPLOY_SHA

# create venv
cd backend/
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt

echo ROBOFLOW_API_KEY=$ROBOFLOW_API_KEY > .env
echo GEMINI_API_KEY=$GEMINI_API_KEY >> .env

pip3 install gunicorn

sudo systemctl daemon-reload
sudo systemctl restart gunicorn
sudo systemctl restart nginx
