import { UUID } from "crypto";
import e, { NextFunction, Request, Response } from "express";
import { eq } from "drizzle-orm";
import { db } from "../db";
import { NewUser, users } from "../db/scehema";

import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";

export interface AuthRequest extends Request {
  user?: UUID;
  token?: string;
}

export const auth = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    // Get the header
    const token = req.header("x-auth-token");
    if (!token) {
      res.status(401).json({ error: "No auth token, access denied" });
      return;
    }

    // Verify if the token is valid
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      res.status(401).json({ error: "Token verification failed" });
      return;
    }

    // Get the user data if the token is valid
    const verifiedToken = verified as { id: UUID };
    const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));

    // If no user, return false
    if (!user) {
      res.status(401).json({ error: "User not found" });
      return;
    }

    req.user = verifiedToken.id;
    req.token = token;

    next();
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({ error: error.message });
    } else {
      res.status(500).json({ error: "An unknown error occurred" });
    }
  }
};
