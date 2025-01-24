import  { Request, Router, Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/scehema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { console } from "inspector";
import { auth, AuthRequest } from "../middleware/auth";
import { error } from "console";
const authRouter = Router();

interface SignUpBody {
    name: string;
    email: string;
    password: string;
}
interface LoginBody{
    email: string;
    password: string;
}
authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        //get req body
        const { name, email, password } = req.body;
        //check if the user already exists 
        const existingUser = await db
        .select().
        from(users)
        .where(eq(users.email, email));
        if(existingUser.length){
             res.status(400).json({msg: "User with the same email already exists  "})
             return;
        }
        //hashed passwortd
      const hashedPassword= await   bcryptjs.hash(password,8);


        // create a new user and sotre in db
        const newUser:NewUser ={
            name,
            email,
            password:hashedPassword,

        };
       const [user]= await db.insert(users).values(newUser).returning()
       res.status(201).json(user);

    } catch (e) {
        res.status(500).json({ error: e });
    }

});
authRouter.post("/login",
    async (req: Request <{},{},LoginBody>,res:Response)=>{
        try {
            //get req body
            const {email,password}=req.body;
            //check if the user doenst exist 
            const [existingUser]= await db
            .select()
            .from(users)
            .where(eq(users.email,email));
            if( !existingUser){
                res.status(400).json({error: "uUser with this email does not exist"});
                return;


            }
            const isMatch=await bcryptjs.compare(password,existingUser.password);

            if(!isMatch){
                res.status(400).json({error:"Incorrect password!"});
                return;
            } 
            const token= jwt.sign({id:existingUser.id},
                "passwordKey"
            );
            res.json({token, ...existingUser});
            
        } catch (error) {
            console.error("Login error: ",error);
            res.status(500).json({error:"Internal server errror"});
            
        }
    }
);
authRouter.post("/tokenIsValid",async(req,res)=>{
    try {
        //get the header
        const token=req.header("x-auth-token");
        if(!token) {
             res.json(false);
             return;};
        //verify if the token is valid 
        const verified= jwt.verify(token,"passwordKey");
        if(!verified) { res.json(false);return;};
        //get the user data if the token is valid
        const verifiedToken=verified as {id:string};
        const [user]=await db.select().from(users).where(eq(users.id,verifiedToken.id))
        //if no user return false 
        if(!user) { res.json(false);return;};
        res.json(true);

        
    } catch (error) {
        res.status(500).json(false)
        
    }
})

authRouter.get("/", auth, async  (req: AuthRequest, res) => {
    try {
        if(!req.user){
            res.status(401).json({error: "User not found"});
            return;

        }
        const [user]=  await db.select().from(users).where(eq(users.id,req.user))
        res.json({...user,token: req.token});
    } catch (error) {
        res.status(500).json(false);
        
    }

});



export default authRouter;