<!doctype html>
<html ng-app="myApp">
 
<head lang="en">
<style = "text/css">
.gridStyle {
    border: 1px solid rgb(212,212,212);
    width: 600px; 
    height: 400px;
}
</style>
        <meta charset="utf-8">
   
         <link rel="stylesheet" type="text/css" href="https://rawgithub.com/angular-ui/ng-grid/2.0.7/ng-grid.css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.0.2/angular.min.js"></script>
        <script type="text/javascript" src="http://angular-ui.github.com/ng-grid/lib/ng-grid.debug.js"></script>
 
    </head>

<script language="javascript">
    var app = angular.module('myApp', ['ngGrid']);

    function MyCtrl($scope, $http) {

        $http.get('http://localhost:8080/rest-angular/rest/service').
        success(function (data) {
            $scope.users = data;
        });

        $scope.removeRow = function (name, surname) {;
            // Delete from Grid
            var index = this.row.rowIndex;

            $scope.gridOptions.selectItem(index, false);
            $scope.users.splice(index, 1);
            alert('delete completed!');

            // Server side
            $http.post('http://localhost:8080/rest-angular/rest/service/delete', {
                name: name,
                surname: surname
            }).
            success(function (data) {


            });
        };

        $scope.saveItem = function (name, surname, address) {
            $http.post('http://localhost:8080/rest-angular/rest/service/save', {
                name: name,
                surname: surname,
                address: address
            }).
            success(function (data) {
                alert('update completed!');
            });
        }
        
        $scope.addRow = function () {

            $scope.hidden = true;

        };
        
        $scope.insertRow = function () {

            // Update ng-grid
            $scope.users.push({
                name: $scope.myForm.name,
                surname: $scope.myForm.surname,
                address: $scope.myForm.address
            });
            $scope.hidden = false;

           // Persist on database
            $http.put('http://localhost:8080/rest-angular/rest/service', {
                name: $scope.myForm.name,
                surname: $scope.myForm.surname,
                address: $scope.myForm.address
            }).
            success(function (data) {
                alert('insert completed!');
            });


        };


        $scope.gridOptions = {
            data: 'users',
            enableRowSelection: false,
            enableCellEditOnFocus: true,
            multiSelect: false,
            columnDefs: [{
                field: 'name',
                displayName: 'name',
                enableCellEdit: false
            }, {
                field: 'surname',
                displayName: 'surname',
                enableCellEdit: false
            }, {
                field: 'address',
                displayName: 'address',
                enableCellEdit: true
            }, {
                field: '',
                displayName: 'Save',
                enableCellEdit: false,
                cellTemplate: '<button id="editBtn" type="button"  ng-click="saveItem(row.entity.name, row.entity.surname,row.entity.address)" >Save</button>'
            }, {
                field: '',
                displayName: 'Delete',
                enableCellEdit: false,
                cellTemplate: '<button id="editBtn" type="button"  ng-click="removeRow(row.entity.name, row.entity.surname)" >Delete</button>'
            }]

        };

    }
</script>
 

<body ng-controller="MyCtrl">
	<div class="gridStyle" ng-grid="gridOptions"></div>
	<button ng-click="addRow()">New Person</button>

</body>
<div ng-show="hidden">
	<form>
		<input type="text" name="firstName" ng-model="myForm.name">First
		name <br /> <input type="text" name="surname"
			ng-model="myForm.surname">Last name <br /> <input type="text"
			name="address" ng-model="myForm.address">Address <br />
		<button ng-click="insertRow()">Save</button>
	</form>
</div>
</html>
