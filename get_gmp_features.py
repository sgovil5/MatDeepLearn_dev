import sys
import ase
import json
import numpy as np
from tqdm import tqdm
from GMPFeaturizer import GMPFeaturizer, ASEAtomsConverter, PymatgenStructureConverter
import argparse

def get_featurizer(params=None):
    if params is None:
        params = {
            "GMPs": {
                "orders": [-1, 0, 1, 2],
                "sigmas": [0.1, 0.2, 0.3]
            },
            # path to the pseudo potential file
            "psp_path": "../GMP-featurizer/pseudopotentials/QE-kjpaw.gpsp",
            # basically the accuracy of the resulting features
            "overlap_threshold": 1e-16,
        }
    
    converter = ASEAtomsConverter()
    featurizer = GMPFeaturizer(
        GMPs=params, 
        converter=converter, 
        calc_derivatives=False, 
        verbose=False
    )
    return featurizer

def get_data_obj(path):
    with open(path) as f:
        data = json.load(f)
    
    return data

def get_features(data, featurizer, disable=False):
    n_errors = 0
    data_list = []

    for i, structure in tqdm(enumerate(data), total=len(data), disable=disable):
        structure_id = structure["structure_id"]
        positions = structure["positions"]
        cell = structure["cell"]
        atomic_numbers = structure["atomic_numbers"]

        s = ase.Atoms(numbers=atomic_numbers, positions=positions, cell=cell)
        s.wrap(pbc=True)

        f = featurizer.prepare_features([s], cores=1)

        if len(f) != 1:
            print("Error: ", structure_id)
            n_errors += 1
            continue

        f = f[0]['features']
        if i == 0:
            print("Shape of the features: ", f.shape)

        json_entry = {
            "structure_id": structure_id,
            "positions": positions,
            "cell": cell,
            "atomic_numbers": atomic_numbers,
            "y": f.tolist(),
        }

        data_list.append(json_entry)

    print("Number of errors: ", n_errors)
    
    return data_list

def get_sigmas(lspace, n_gaussians):
    return np.linspace(0, lspace, n_gaussians+1, endpoint=True)[1:].tolist()

def get_orders(max_order):
    # append -1 to the beginning of the list
    orders = [-1]
    orders.extend([i for i in range(max_order+1)])
    return orders

def get_orders_and_sigmas(lspace, max_order, n_gaussians):
    return get_orders(max_order), get_sigmas(lspace, n_gaussians)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Input linspace, orders, and sigmas")
    parser.add_argument("--linspace", '-l', type=float, default=0.3, help="linspace")
    parser.add_argument("--orders", '-o', type=int, default=2, help="orders")
    parser.add_argument("--sigmas", '-s', type=int, default=6, help="sigmas")
    args = parser.parse_args()
    lspace = args.linspace
    order = args.orders
    sigma = args.sigmas
    
    # get orders and sigma
    orders, sigmas = get_orders_and_sigmas(lspace, order, sigma)

    params = {
        "GMPs": {
            "orders": orders,
            "sigmas": sigmas
        },
        # path to the pseudo potential file
        "psp_path": "../GMP-featurizer/pseudopotentials/QE-kjpaw.gpsp",
        # basically the accuracy of the resulting features
        "overlap_threshold": 1e-16,
    }

    # name of json to be saved
    fname = f'data/mp_data_forces/generated_features/linspace{lspace}_orders{order}_sigmas{sigma}.json'
    # path to original dataset
    path = 'data/mp_data_forces/MP_data_forces/raw/data_relaxed.json'

    data = get_data_obj(path)
    featurizer = get_featurizer(params)
    data_list = get_features(data, featurizer)
    
    # save data_list to json file
    with open(fname, 'w') as f:
        json.dump(data_list, f)
        
