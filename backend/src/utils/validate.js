const {
    check, validationResult
} = require('express-validator');
const {
    wrapResponse, STATUS_CODE
} = require('../utils/http');

const checkWrapper = (req, res, next) => {
    try {
        const errors = validationResult(req);
        if (errors.isEmpty()) {
            return next();
        }
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_422_UNPROCESSABLE_ENTITY,
            error: errors.array()
        });
    } catch (err) {
        next(err);
    }
};

const validate = (standard) => {
    let validators = [];
    for (let prop in standard) {
        if (typeof standard[prop] === 'object') {
            for (let subProp in standard[prop]) {
                let oldProp = subProp;
                let newProp = prop + "." + subProp;
                standard[prop][newProp] = standard[prop][oldProp];
                delete standard[prop][oldProp];
            }
            validators.push(...validate(standard[prop]));
        } else {
            let cmd = standard[prop];
            let params = cmd.split('&');
            let validator = check(prop);
            let msg = prop + " must be satisfied with:";
            params.forEach(p => {
                let [func, args] = p.trim().split('=');
                validator = args ? validator[func](
                    JSON.parse(args)
                ) : validator[func]();
                msg += `-> ${func}(${args || ""})`;
            });
            validator = validator.withMessage(msg);
            validators.push(validator);
        }
    }
    return validators.concat([checkWrapper]);
};

module.exports = {
    validate
};
