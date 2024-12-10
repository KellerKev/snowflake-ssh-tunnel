import os
import json

service_secrets_string=os.environ['SERVICESECRETS']
service_secrets_dict=json.loads(service_secrets_string)


f = open("/home/spcstunnel/env", "w")
f.write("")
f.close()



def split_json_layers(data):
    # Initialize dictionaries for outer and nested layers
    outer_layer = {}
    nested_layer = {}

    # Loop through the JSON data
    for key, value in data.items():
        # Check if the value is a list containing dictionaries (indicating nested data)
        if isinstance(value, list) and all(isinstance(item, dict) for item in value):
            nested_layer[key] = value  # Add to nested layer
        else:
            outer_layer[key] = value  # Add to outer layer

    # Return both dictionaries
    return outer_layer, nested_layer




data = service_secrets_dict

outer_layer, nested_layer = split_json_layers(data)


f = open("/home/spcstunnel/env", "a")

for secret, value in outer_layer.items():
    f.writelines([secret, "=", '"', value,'"','\n'])

for k,v in nested_layer.items():
    for vlist in v:
        for secret, value in vlist.items():

            f.writelines([secret, "=", '"', value,'"','\n'])
f.close()
