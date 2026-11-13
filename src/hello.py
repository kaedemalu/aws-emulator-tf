import json


def handler(event, context):
    name = event.get("name", "World")
    print(f"received event: {json.dumps(event)}")

    return {
        "statusCode": 200,
        "body": json.dumps({"message": f"Hello, {name}!", "input": event}),
    }
