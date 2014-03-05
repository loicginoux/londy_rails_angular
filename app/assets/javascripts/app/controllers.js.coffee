window.londy.controller 'MainCtrl', ($scope,  Restangular, sharedProps) ->
  $scope.$watch( (()-> sharedProps.selectedTab) , (newVal, oldVal, scope) -> 
    $scope.selectedTab = newVal
  ,true) 


window.londy.controller 'ProjectListCtrl', ($scope,  Restangular, sharedProps, $state, $stateParams) ->
  serverProjects = Restangular.one('teams', window.gon.params.id).all('projects')
  serverProjects.getList().then((list) ->
    $scope.projects = list
    proj = _.find(list, (item)-> 
      return item.id == parseInt($state.params.id)
    )
    $scope.selectProject(proj) if proj
  )

  $scope.editedProject = null
  $scope.newProject = ''

  # init tab
  sharedProps.selectedTab = "projects" if $state.includes("projects")


  $scope.$watch( (()-> sharedProps.selectedTab) , (newVal, oldVal, scope) -> 
    console.log "ProjectListCtrl:", newVal
    $scope.selectedTab = newVal
  ,true) 

  $scope.selectProject = (proj) -> 
    $scope.selectedProject = proj
    sharedProps.selectedProject = proj


  $scope.addProject = () -> 
    console.log "add project"
    newProj = $scope.newProject.trim()
    if newProj.length == 0
      return
    serverProjects.post({name: newProj}).then((savedProj)->
      $scope.projects.push(savedProj)
    )
    $scope.newProject = ''


  $scope.editProject = (proj) -> 
    console.log "edit proj", proj
    $scope.editedProject = proj
    $scope.originalProject = angular.extend({}, proj)

  $scope.deleteProject = (proj) -> 
    console.log("delete:",proj)
    $scope.editedProject = null
    $scope.originalProject.remove().then(()->
      $scope.projects = _.without($scope.projects, proj)
    )

  $scope.save = (proj) -> 
    console.log("save:",proj)
    proj.name = proj.name.trim()
    if (!proj.name) 
      $scope.deleteProject(proj)
    proj.put()
    $scope.editedProject = null

  
  $scope.onKeyDown = (event, proj) -> 
    console.log("onKeyDown:", event.keyCode, proj, $scope.originalProject)
    $scope.save(proj) if event.keyCode == 13
    return if event.keyCode != 27
    $scope.projects[$scope.projects.indexOf(proj)] = $scope.originalProject
    $scope.editedProject = null





window.londy.controller 'TeamListCtrl', ($scope,  Restangular, sharedProps, $state) ->
  serverUsers = Restangular.one('teams', window.gon.params.id).all('users')
  $scope.users = serverUsers.getList().$object
  $scope.editedUser = null
  $scope.newUser = ''
  sharedProps.selectedTab = "users" if $state.includes("users")


  $scope.$watch( (()-> sharedProps.selectedTab), (newVal, oldVal, scope) -> 
    console.log newVal
    $scope.selectedTab = newVal
  ,true) 

  $scope.addUser = () -> 
    console.log "add user"
    newEmail = $scope.newEmail.trim()
    if newEmail.length == 0
      return
    serverUsers.post({email: newEmail})

  $scope.selectUser = (u) -> 
    $scope.selectedUser = u
    sharedProps.selectedUser = u


window.londy.controller 'editAccountNavCtrl', ($scope,  Restangular, sharedProps, $state) ->
  sharedProps.selectedTab = "profile" if $state.includes("profile")

  $scope.$watch( (()-> sharedProps.selectedTab), (newVal, oldVal, scope) -> 
    console.log newVal
    $scope.selectedTab = newVal
  ,true) 


window.londy.controller 'taskListCtrl', ($scope,  Restangular, sharedProps) ->
  $scope.selectedProject = sharedProps.selectedProject
  $scope.tasks = []
  $scope.editedTask = null
  $scope.newTask = ''
  console.log("tasks for proj:",$scope.selectedProject)
  serverTasks = null
  $scope.$watch( (()-> sharedProps.selectedProject), (newVal, oldVal, scope) -> 
    return if !newVal
    console.log("changed tasks for proj:",newVal)
    $scope.selectedProject = newVal
    console.log("tasks for proj:",$scope.selectedProject)
    serverTasks = Restangular.one('teams', window.gon.params.id).one('projects', newVal.id).all('tasks')
    $scope.tasks = serverTasks.getList().$object
  ,true) 

  $scope.toggleComplete = (task) -> 
    console.log("complete:",task)
    task.completed = !task.completed
    task.put()

  $scope.editTask = (task) -> 
    console.log "edit task", task
    $scope.editedTask = task
    $scope.originalTask = angular.extend({}, task)

  $scope.deleteTask = (task) -> 
    console.log("delete:",task)
    $scope.editedTask = null
    $scope.originalTask.remove().then(()->
      $scope.tasks = _.without($scope.tasks, task)
    )

  $scope.save = (task) -> 
    console.log("save:",task)
    task.content = task.content.trim()
    if (!task.content) 
      $scope.deleteTask(task)
    task.put()
    $scope.editedTask = null

  
  $scope.onKeyDown = (event, task) -> 
    console.log("onKeyDown:", event.keyCode, task, $scope.originalTask)
    $scope.save(task) if event.keyCode == 13
    return if event.keyCode != 27
    $scope.tasks[$scope.tasks.indexOf(task)] = $scope.originalTask
    $scope.editedTask = null  

  $scope.addTask = () -> 
    console.log "add"
    newT = $scope.newTask.trim()
    if newT.length == 0
      return
    serverTasks.post({content: newT, project_id: $scope.selectedProject.id}).then((savedObj)->
      $scope.tasks.push(savedObj)
    )
    $scope.newTask = ''
