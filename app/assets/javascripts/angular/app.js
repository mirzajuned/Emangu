var myApp = angular.module('Emangu', ['ngRoute', 'ngResource']);

//Routes

myApp.config([
    '$routeProvider', '$locationProvider', function ($routeProvider, $locationProvider) {
        $routeProvider.when('/posts', {
            templateUrl: '/templates/posts/index.html',
            controller: 'PostsListCtr'
        });
        $routeProvider.when('/index', {
                templateUrl: '/template/index.html',
            

        }).otherwise({
           templateUrl: '/template/index.html' 
        })


    }
]);

//Controllers

myApp.controller("PostsListCtr", ['$scope', '$http', '$resource', 'Posts', '$location', function ($scope, $http, $resource, Posts, $location) {

    $scope.posts = Posts.list();

//    $scope.deletePost = function (Post) {
//        if (confirm("Are you sure you want to delete this Post?")) {
//            Post.delete({ id: Post }, function () {
//                $scope.posts = Posts.list();
//                $location.path('/');
//            });
//        }
//    };
}]);


myApp.factory('Posts', ['$resource', function ($resource) {
    return $resource('/posts.json', {}, {
        list: { method: 'GET', isArray: true },
        create: { method: 'POST' }
    })
}]);