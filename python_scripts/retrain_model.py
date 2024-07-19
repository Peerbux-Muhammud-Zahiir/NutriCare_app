import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import csv
import os

def load_dataset(dataset_path):
    images = []
    labels = []
    with open(dataset_path, 'r') as f:
        reader = csv.reader(f)
        for row in reader:
            image_path, label = row
            image = tf.keras.preprocessing.image.load_img(image_path, target_size=(224, 224))
            image = tf.keras.preprocessing.image.img_to_array(image)
            images.append(image)
            labels.append(label)
    return tf.convert_to_tensor(images), tf.convert_to_tensor(labels)

def retrain_model(images, labels, original_model_path):
    model = tf.keras.models.load_model(original_model_path)
    model.fit(images, labels, epochs=10)
    return model

dataset_path = 'assets/foodpretrainedmodel.csv'
original_model_path = 'assets/foodpretrainedmodel.tflite'
images, labels = load_dataset(dataset_path)
model = retrain_model(images, labels, original_model_path)
model.save('lib/AI Stuff/retrained_model')

# Convert to TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with open('lib/AI Stuff/model.tflite', 'wb') as f:
    f.write(tflite_model)

# Update the CSV file with the new label
def update_csv(new_label, csv_path):
    with open(csv_path, 'a') as f:
        f.write(f'\n{new_label}')

csv_path = 'assets/foodpretrainedmodel.csv'
existing_labels = []  # Load existing labels from CSV if needed
new_labels = set(labels.numpy()) - set(existing_labels)
for label in new_labels:
    update_csv(label, csv_path)