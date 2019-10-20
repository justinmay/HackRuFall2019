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
          paid: 0,
          items: [],
          itemMap: {}
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
  console.log(items)

  dedupItems = []
  items.forEach(function(i) {
    quantity = i.quantity
    console.log(i)

    for (var x = 1; x <= quantity; x++) {
      dedupItems.push({
        name: i.name+"-"+x,
        price: i.price
      })
    }
  })

  db.get().collection('sessions').updateOne({
    restaurantId: parseInt(req.params.restaurantId),
    tableId: parseInt(req.params.tableId),
    active: true
  }, {
    $set: {
      items: dedupItems,
    },
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

router.get("/restaurants/:restaurantId/tables/:tableId/receipt", function(req, res, next) {
  db.get().collection('sessions').findOne({
    tableId: parseInt(req.params.tableId),
    restaurantId: parseInt(req.params.restaurantId)
  }, {
    projection: {
      items: 1
    }
  }, function(err, result) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      console.log(result)
      res.json({status: "success", items: result.items})
    }
  })
});

router.post("/restaurants/:restaurantId/tables/:tableId/pay", function(req, res, next) {
  var itemsToPay = req.body.items
  var username = req.query.username 

  var updateObj = {
    $set: {
    },
    $inc: {
      paid: 1
    }
  }
  updateObj["$set"]["itemMap."+username] = itemsToPay

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

router.post("/restaurants/:restaurantId/tables/:tableId/finish", function(req, res, next) {
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
        tableId: parseInt(req.params.tableId),
        restaurantId: parseInt(req.params.restaurantId),
        active: true
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

router.get("/restaurants/:restaurantId/tables/:tableId/ledger", function(req, res, next) {
  db.get().collection('ledgers').findOne({
    tableId: parseInt(req.params.tableId),
    restaurantId: parseInt(req.params.restaurantId)
  }, function(err, result) {
    if (err) {
      console.log(err)
      res.json({status: "error"})
    } else {
      out = []
      Object.keys(result.oweMap).forEach(function(key) {
        out.push({
          name: key,
          owed: result.oweMap[key]
        })
      })
      res.json(out)
    }
  })
});

module.exports = router;
