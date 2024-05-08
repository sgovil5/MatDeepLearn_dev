from sklearn.preprocessing import RobustScaler, MinMaxScaler
import numpy as np
import json
import argparse

parser = argparse.ArgumentParser(description="Input linspace, orders, and sigmas")
parser.add_argument("--linspace", '-l', type=float, default=0.3, help="linspace")
parser.add_argument("--orders", '-o', type=int, default=2, help="orders")
parser.add_argument("--sigmas", '-s', type=int, default=6, help="sigmas")
args = parser.parse_args()
linspace = args.linspace
orders = args.orders
sigmas = args.sigmas


fname = f"data/mp_data_forces/generated_features/linspace{linspace}_orders{orders}_sigmas{sigmas}.json"
with open(fname, "r") as f:
    original_data = json.load(f)


# scale the features using robust scaler
robust = RobustScaler()
data = original_data.copy()
# scale the features
all_y = [item for sublist in data for item in sublist["y"]]

# Convert list to numpy array and reshape for fitting
all_y_array = np.array(all_y).reshape(-1, 1)  # reshape to (n_samples, n_features) where n_features is 1

# Scale the combined list of all 'y' values
scaled_y = robust.fit_transform(all_y_array).flatten()

# Reassign scaled 'y' values back to each dataset
index = 0
for d in data:
    num_y = len(d["y"])
    d["y"] = scaled_y[index:index + num_y].tolist()
    index += num_y
# save the scaled features
fname = f"data/mp_data_forces/generated_features/linspace{linspace}_orders{orders}_sigmas{sigmas}_robust.json"
with open(fname, "w") as f:
    json.dump(data, f)

# scale the features using minmax scaling
data = original_data.copy()
# scale the features
minmax = MinMaxScaler()
all_y = [item for sublist in data for item in sublist["y"]]

# Convert list to numpy array and reshape for fitting
all_y_array = np.array(all_y).reshape(-1, 1)  # reshape to (n_samples, n_features) where n_features is 1

# Scale the combined list of all 'y' values
scaled_y = minmax.fit_transform(all_y_array).flatten()

# Reassign scaled 'y' values back to each dataset
index = 0
for d in data:
    num_y = len(d["y"])
    d["y"] = scaled_y[index:index + num_y].tolist()
    index += num_y
# save the scaled features
fname = f"data/mp_data_forces/generated_features/linspace{linspace}_orders{orders}_sigmas{sigmas}_minmax.json"
with open(fname, "w") as f:
    json.dump(data, f)