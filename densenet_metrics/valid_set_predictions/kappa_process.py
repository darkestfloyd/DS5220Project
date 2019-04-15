import pandas as pd
from sklearn.metrics import cohen_kappa_score, accuracy_score

study_s = ['elbow', 'wrist', 'shoulder', 'forearm', 'hand', 'finger', 'humerus']
accuracy = []
kappa = []
for study in ['elbow', 'wrist', 'shoulder', 'forearm', 'hand', 'finger', 'humerus']:
    preds = pd.read_csv('./pred_{0}.csv'.format(study), index_col=0)
    accuracy.append(accuracy_score(preds.Abnormal_Label, preds.Abormal_Prediction))
    kappa.append(cohen_kappa_score(preds.Abnormal_Label, preds.Abormal_Prediction))
    
metrics = pd.DataFrame({'study': study_s, 'accuracy': accuracy, 'kappa': kappa})
metrics.to_csv('./valid_metrics.csv', index=None)