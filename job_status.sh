SECONDS=0
TIMEOUT=3600
expected_state='"SUCCEEDED"'
auth_token="$(gcloud auth print-access-token)"
state=$(curl -X GET \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $auth_token" \
	"https://content-ml.googleapis.com/v1/projects/$1/jobs/$2" | jq .state)

while [[ $SECONDS -lt $TIMEOUT ]]
do
  if [ "$state" == "$expected_state" ]; then
    echo "Job succeeded! All done!"
    break
  else
    echo "Got $state :( Not done yet..."
  fi

  ((SECONDS++))
  sleep 120
  state=$(curl -X GET \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $auth_token" \
	"https://content-ml.googleapis.com/v1/projects/$1/jobs/$2" | jq .state)
done

if [ $SECONDS -gt $TIMEOUT ]; then
    echo "TIMEOUT reached.."
    exit 1
fi
