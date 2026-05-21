# Intent Classifier Model

This small project demonstrates:
- Training a tiny text classifier.
- Saving the model artifact.
- Serving predictions via a Flask API (`/predict`).

## Quick start (local)
1. Create a virtualenv and install:
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt

2. Train the model:
    python model/train.py
    This will create `model/artifacts/intent_model.pkl`.

3. Run the API:
    python app.py
    The API will be available at http://127.0.0.1:6000

4. Example request:
    curl -X POST http://127.0.0.1:6000/predict -H "Content-Type: application/json" -d '{"text":"I want to cancel my subscription"}'

    Response:
    {
        "intent": "complaint",
        "probabilities": {"complaint": 0.85, "question": 0.05, ...}
    }


AWS console\
1. Get AMI ID 
aws ec2 describe-images \
> --owners 099720109477 \
> --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" "Name=state,Values=available" \
> --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' --output text --region $AWS_REGION

AMI ID
ami-06cc5ebfb8571a147
cat /opt/intent-app/requirements.txt
ls /opt/intent-app/
sudo cat /var/log/cloud-init-output.log | tail -50

# restart auto scaling group
aws autoscaling start-instance-refresh --auto-scaling-group-name mlops-autoscaling \