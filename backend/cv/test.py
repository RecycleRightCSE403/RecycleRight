import classify

response = classify.run_model('test2.jpeg', image_folder='../images/')
print(response['predictions'])
