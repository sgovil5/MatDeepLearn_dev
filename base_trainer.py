# Loads portion of model dict into a new model for fine tuning
def load_pre_trained_weights(self, load_training_state=False):
    """Loads the pre-trained model from a checkpoint.pt file"""

    if not self.checkpoint_path:
        raise ValueError("No checkpoint directory specified in config.")
        checkpoints_folder = os.path.join(self.fine_tune_from, 'checkpoint')
     
    self.checkpoint_path = self.checkpoint_path.split(",")
    load_model = [torch.load(i, map_location=self.device) for i in self.checkpoint_path]
    load_state = [i["state_dict"] for i in load_model]
    model_state = [i.state_dict() for i in self.model]

    for x in range(len(self.model)):
        for name, param in load_state[x].items():
            #if name not in model_state or name.split('.')[0] in "post_lin_list":
            if name not in model_state[x]:
                logging.debug('NOT loaded: %s', name)
                continue
            else:
                logging.debug('loaded: %s', name)
            if isinstance(param, torch.nn.parameter.Parameter):
                # backwards compatibility for serialized parameters
                param = param.data
            
            model_shape = model_state[x][name].shape
            param_shape = param.shape

            if tuple(model_shape) != tuple(param_shape):
                print("Shape mismatch, skipping: ", name, param.shape, model_shape)
                continue

            model_state[x][name].copy_(param)
        logging.info("Loaded pre-trained model with success.")
        if load_training_state == True:
            if checkpoint.get("optimizer"): 
                self.optimizer[x].load_state_dict(checkpoint["optimizer"])
            if checkpoint.get("scheduler"):     
                self.scheduler[x].scheduler.load_state_dict(checkpoint["scheduler"])
                self.scheduler[x].update_lr()
                #if checkpoint.get("epoch"):
                #   self.epoch = checkpoint["epoch"]
                #if checkpoint.get("step"):
                #    self.step = checkpoint["step"]
                #if checkpoint.get("best_metric"): 
                #    self.best_metric = checkpoint["best_metric"]
            if checkpoint.get("seed"): 
                seed = checkpoint["seed"]
                self.set_seed(seed)
            if checkpoint.get("scaler"):
                self.scaler.load_state_dict(checkpoint["scaler"])