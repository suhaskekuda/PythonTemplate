import re
import requests
import json
import jsonpath
import pytest
import os
import sys

sys.path.append(os.path.join(os.path.dirname(
    os.path.realpath(__file__)), os.pardir))
from app_utils import *

testSuitRules = readJson("test/testCase.json")

baseUrl = testSuitRules["Setting"]["AppURL"]
testCase = testSuitRules["TestCase"]
ids = [item.get('TestId') for item in testCase]


@pytest.mark.parametrize("data", testCase, ids=ids)
def test_usecase(data):
    path = data["Route"]
    params = data["Params"]
    test_usecase.__doc__ = data["TestCase"]
    reqHeader = {}

    fetchURL = "{}{}".format(baseUrl, path)
    
    if testSuitRules["Setting"]["TestType"] == "URL" :
        response = requests.get(url=fetchURL, params=params, headers=reqHeader)
        responseJson = json.loads(response.text)
    
        assert response.status_code == data["StatusCode"]
        assert responseJson == data["ExceptedResponse"]