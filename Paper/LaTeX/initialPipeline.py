X_train, X_test, y_train, y_test = getTrainTestSplit(dataFrame)
C = uniform(loc=0, scale=4).rvs(10)
refitScore = 'precision_score'
param_grid = [
    {
        'classifier__C': C,
        'classifier__penalty':['l1', 'l2']
    }
]

transformPipeline = Pipeline([
    ('Initial drop cols', 
    DFTransform(
        lambda X: X.drop([customerIdKey,'firstInvoiceDate'], axis=1)
        )
    ),
    ('Remove catagorical', 
    DFTransform(
        lambda X: X.select_dtypes(exclude=['object'])
        )
    ),
])
clfPipeline = Pipeline([
    ('scaler',StandardScaler()),
    ('classifier', LogisticRegression())
])

transformedDfX_test = transformPipeline.transform(X_train)
bestModel = GridSearchCVOnPipeline(
    transformedDfX_test, y_train, clfPipeline, param_grid, refitScore
    )

transformedDfX_test = transformPipeline.transform(X_test)
BestModelScore(transformedDfX_test, y_test, bestModel, refitScore)