var express = require('express');
var router = express.Router();
var db = require('../db');

/* GET home page. */
router.get('/restaurants/:restaurantId/items', function(req, res, next) {
  db.get().collection("random").findOne({a: 1}, function(err, response) {console.log(response)})
  db.get().collection("restaurants").findOne({
    _id: parseInt(req.params.restaurantId)
  }, {
    projection: {
      items: 1
    }
  }, function(err, restaurant) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      console.log(restaurant.items)
      res.json({status: "success", items: restaurant.items})
    }
  })
});

router.get("/restaurants/:restaurantId/tables", function(req, res, next) {
  db.get().collection("tables").find({
    restaurantId: parseInt(req.params.restaurantId)
  }, function(err, tables) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      tables.toArray(function(err, result) {
        console.log(result)
        res.json({status: "success", tables: result})
      })
    }
  })
});

router.get("/restaurants/:restaurantId/tables/:tableId" , function(req, res, next) {
  db.get().collection('tables').findOne({
    restaurantId: parseInt(req.params.restaurantId),
    _id: parseInt(req.params.tableId)
  }, function(err, table) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      console.log(table.people)
      res.json({status: "success", people: table.people})
    }
  })
});

router.post("/restaurants/:restaurantId/tables/:tableId/verify", function(req, res, next) {
  var username = req.query.username;

  db.get().collection('tables').updateOne({
    restaurantId: parseInt(req.params.restaurantId),
    _id: parseInt(req.params.tableId)
  }, {
    $push: {
      people: username
    }
  }, function(err, table) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      db.get().collection('sessions').updateMany({
        restaurantId: parseInt(req.params.restaurantId),
        tableId: parseInt(req.params.tableId),
        active: true
      }, {
        $set: {
          restaurantId: parseInt(req.params.restaurantId),
          tableId: parseInt(req.params.tableId),
          active: true,
          itemMap: {},
          paid: 0
        }
      }, {
        upsert: true
      }, function(err, session) {
        if (err) {
          console.log(err)
          res.json({status: "error"})
        } else {
          console.log(table.people)
          res.json({status: "success"})
        }
      })
    }
  })
});

router.post("/restaurants/:restaurantId/tables/:tableId/submit", function(req, res, next) {
  var items = req.body;

  db.get().collection('sessions').updateOne({
    restaurantId: parseInt(req.params.restaurantId),
    tableId: parseInt(req.params.tableId),
    active: true
  }, {
    $set: {
      items: items
    }
  }, function(err, result) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else if (result.modifiedCount == 0) {
      console.log("no session found")
      res.json({status: "error"})
    } else {
      res.json({status: "success"})
    }
  })
});

router.post("/restaurants/:restaurantId/tables/:tableId/pay", function(req, res, next) {
  var itemsToPay = req.body.pay
  var isPayerStr = req.query.isPayer
  var username = req.query.username 


  pushMap = {}
  for (var i in itemsToPay) {
    pushMap["itemMap." + i] = username
  }

  var updateObj = {
    $push: pushMap,
    $inc: {
      paid: 1
    }
  }
  if (isPayerStr) {
    updateObj["$set"] = {
      payer: username
    }
  }

  db.get().collection('sessions').updateOne({
    restaurantId: parseInt(req.params.restaurantId),
    tableId: parseInt(req.params.tableId),
    active: true
  }, updateObj, function(err, result) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      res.json({status: "success"})
    }
  }) 
});

router.get("/restaurants/:restaurantId/tables/:tableId/finish", function(req, res, next) {
  db.get().collection('tables').updateOne({
    _id: parseInt(req.params.tableId),
    restaurantId: parseInt(req.params.restaurantId)
  }, {
    $set: {
      people: []
    }
  }, function(err, result) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      db.get().collection('sessions').updateOne({
        _id: parseInt(req.params.tableId),
        restaurantId: parseInt(req.params.restaurantId)
      }, {
        $set: {
          active: false
        }
      }, function(err, result) {
        if (err) {
          console.log(err)
          res.json({status: "error"})
        } else {
          res.json({status: "success"})
        }
      })
    }
  })
});

module.exports = router;
