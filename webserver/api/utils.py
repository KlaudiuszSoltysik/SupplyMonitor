from datetime import datetime, timedelta
import pickle

def generateSupplyData():
    current_timestamp = datetime.now()
    rounded_minutes = current_timestamp.minute - (current_timestamp.minute % 15)
    rounded_timestamp = current_timestamp.replace(minute=rounded_minutes,
                                                  second=0,
                                                  microsecond=0)

    file_path = rf''

    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    entries = [line.strip() for line in lines]

    resp = [{'timestamp': rounded_timestamp - i * timedelta(minutes=15),
             'value': entries[i]} for i in range(len(entries))]

    with open('data.txt', 'wb') as file:
        pickle.dump(resp, file)
    print('Dictionary saved to data.txt')

    # with open(f"data{i}.txt", "rb") as file:
    #     loaded_data = pickle.load(file)
    #
    # print("Loaded dictionary:", loaded_data)
