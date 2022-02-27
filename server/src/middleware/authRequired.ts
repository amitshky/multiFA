import {Request,Response, NextFunction} from 'express';
import {get} from 'lodash';

const authRequired = async (req: Request, res: Response, next: NextFunction) =>{
    const user = get(req, 'user');
    if(!user)
        return res.sendStatus(403);
    
    return next();   
}

export default authRequired;