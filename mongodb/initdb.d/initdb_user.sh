#!/usr/bin/env bash
echo "Creating mongo users..."

mongo admin -u root -p root123456 << EOF
use test_db;
db.createUser({
    user: 'test',
    pwd: 'test123456',
    roles: [{
        role: 'dbOwner',
        db: 'test_db'
    }]
});
EOF

mongo admin -u root -p root123456 << EOF
use prod_db;
db.createUser({
    user: 'prod',
    pwd: 'prod123456',
    roles: [{
        role: 'dbOwner',
        db: 'prod_db'
    }]
});
EOF

echo "Mongo users created..."
