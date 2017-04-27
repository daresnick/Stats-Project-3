import warningswarnings.filterwarnings('ignore')
import numpy as npimport pandas as pdimport 
matplotlib.pyplot as pltimport 
seaborn as sns
from sklearn.decomposition import PCA, KernelPCA
from sklearn.cross_validation 
import KFold, cross_val_scorefrom sklearn.metrics 
import make_scorerfrom sklearn.grid_search 
import GridSearchCV
from sklearn.feature_selection 
import VarianceThreshold, RFE, SelectKBest, chi2from sklearn.preprocessing 
import MinMaxScalerfrom sklearn.pipeline import Pipeline, FeatureUnion
#from sklearn.linear_model import LogisticRegression
#from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
#from sklearn.neighbors import KNeighborsClassifier
#from sklearn.tree import DecisionTreeClassifier
#from sklearn.naive_bayes import GaussianNB
#from sklearn.svm import SVC
#from sklearn.ensemble import BaggingClassifier, ExtraTreesClassifier, GradientBoostingClassifier, VotingClassifier, RandomForestClassifier, AdaBoostClassifier
from sklearn.ensemble import RandomForestClassifier, VotingClassifier
sns.set_style('whitegrid')pd.set_option('display.max_columns', None)
#Read Data 
setdf = pd.read_csv('C:/Users/rgoyal/Desktop/MS-Data Science/Experimental Statistics-2/Project-3/Kobe1.csv')
#Getting to know the datadf.dtypes
#Descriptive statistics
df.describe(include =['number'])
df.describe(include=['object', 'category'])
#Set Indexes and conversion of some columns to 'category'df.set_index('shot_id', inplace=True)
#Data Visualization
ax = plt.axes()sns.countplot(x='shot_made_flag', data=df, ax=ax);ax.set_title('Target class distribution')plt.show()
f, axarr = plt.subplots(4, 2, figsize=(15, 15))sns.boxplot(x='lat', y='shot_made_flag', data=df, showmeans=True, ax=axarr[0,0])sns.boxplot(x='lon', y='shot_made_flag', data=df, showmeans=True, ax=axarr[0, 1])sns.boxplot(x='loc_y', y='shot_made_flag', data=df, showmeans=True, ax=axarr[1, 0])sns.boxplot(x='loc_x', y='shot_made_flag', data=df, showmeans=True, ax=axarr[1, 1])sns.boxplot(x='minutes_remaining', y='shot_made_flag', showmeans=True, data=df, ax=axarr[2, 0])sns.boxplot(x='seconds_remaining', y='shot_made_flag', showmeans=True, data=df, ax=axarr[2, 1])sns.boxplot(x='shot_distance', y='shot_made_flag', data=df, showmeans=True, ax=axarr[3, 0])
axarr[0, 0].set_title('Latitude')axarr[0, 1].set_title('Longitude')axarr[1, 0].set_title('Loc y')axarr[1, 1].set_title('Loc x')axarr[2, 0].set_title('Minutes remaining')axarr[2, 1].set_title('Seconds remaining')axarr[3, 0].set_title('Shot distance')
plt.tight_layout()plt.show()
sns.pairplot(df, vars=['loc_x', 'loc_y', 'lat', 'lon', 'shot_distance'], hue='shot_made_flag', size=3)plt.show()
# Data Cleaningdata_cl = df.copy() # create a copy of data frametarget = data_cl['shot_made_flag'].copy()
# Remove some columnsdata_cl.drop('match', axis=1, inplace=True) # Always one numberdata_cl.drop('team_id', axis=1, inplace=True) # Always one numberdata_cl.drop('lat', axis=1, inplace=True) # Correlated with loc_xdata_cl.drop('lon', axis=1, inplace=True) # Correlated with loc_ydata_cl.drop('game_id', axis=1, inplace=True) # Independentdata_cl.drop('game_event_id', axis=1, inplace=True) # Independentdata_cl.drop('team_name', axis=1, inplace=True) # Always LA Lakersdata_cl.drop('shot_made_flag', axis=1, inplace=True)data_cl.drop('matchup', axis=1, inplace=True) # Always one number
#Data Transformation# Remaining timedata_cl['seconds_from_period_end'] = 60 * data_cl['minutes_remaining'] + data_cl['seconds_remaining']data_cl['last_5_sec_in_period'] = data_cl['seconds_from_period_end'] < 5
data_cl.drop('minutes_remaining', axis=1, inplace=True)data_cl.drop('seconds_remaining', axis=1, inplace=True)data_cl.drop('seconds_from_period_end', axis=1, inplace=True)
# Game datedata_cl['game_date'] = pd.to_datetime(data_cl['game_date'])data_cl['game_year'] = data_cl['game_date'].dt.yeardata_cl['game_month'] = data_cl['game_date'].dt.month#data_cl.drop('game_date', axis=1, inplace=True)
# Loc_x, and loc_y binningdata_cl['loc_x'] = pd.cut(data_cl['loc_x'], 25)data_cl['loc_y'] = pd.cut(data_cl['loc_y'], 25)
# Replace 20 least common action types with value 'Other'rare_action_types = data_cl['action_type'].value_counts().sort_values().index.values[:20]data_cl.loc[data_cl['action_type'].isin(rare_action_types), 'action_type'] = 'Other'
#Computing Indicator/Dummy Variablescategorial_cols = [    'action_type', 'combined_shot_type', 'period', 'season', 'shot_type',    'shot_zone_area', 'shot_zone_basic', 'shot_zone_range', 'game_date',    'opponent', 'loc_x', 'loc_y']
for cc in categorial_cols:    dummies = pd.get_dummies(data_cl[cc])    dummies = dummies.add_prefix("{}#".format(cc))    data_cl.drop(cc, axis=1, inplace=True)    data_cl = data_cl.join(dummies)
# Feature Selectionunknown_mask = df['shot_made_flag'].isnull()data_submit = data_cl[unknown_mask]
X = data_cl[~unknown_mask]Y = target[~unknown_mask]
#Hyperparameter tuning
seed = 7processors=1num_folds=3num_instances=len(X)scoring='log_loss'
kfold = KFold(n=num_instances, n_folds=num_folds, random_state=seed)
        #Random Forestrf_grid = GridSearchCV(    estimator = RandomForestClassifier(warm_start=True, random_state=seed),    param_grid = {        'n_estimators': [100, 200],        'criterion': ['gini', 'entropy'],        'max_features': [18, 20],        'max_depth': [8, 10],        'bootstrap': [True]    },     cv = kfold,     scoring = scoring,     n_jobs = processors)
rf_grid.fit(X, Y)print(rf_grid.best_score_)
## FInal Prediction
estimators = []
estimators.append(('rf', RandomForestClassifier(bootstrap=True, max_depth=8, n_estimators=200, max_features=20, criterion='entropy', random_state=seed)))
ensemble = VotingClassifier(estimators, voting='soft', weights=[3])
model = ensemble
model.fit(X, Y)preds = model.predict_proba(data_submit)
submission = pd.DataFrame()submission["shot_id"] = data_submit.indexsubmission["shot_made_flag"]= preds[:,0]
submission.to_csv("C:/Users/rgoyal/Desktop/MS-Data Science/Experimental Statistics-2/Project-3/sub.csv",index=False)
