import { pgTable, timestamp, uuid ,text} from "drizzle-orm/pg-core";
import { title } from "process";

export const users= pgTable("users",{
    id:uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    email:text("email").notNull().unique(),
    password:text("password").notNull(),
    createdAt:timestamp("created_at").defaultNow(),
    updatedAt:timestamp("updated_at").defaultNow()
});

export type User=typeof users.$inferSelect;// Veritabanından veri çekerken kullanılacak tip
export type NewUser=typeof users.$inferInsert;// Yeni kullanıcı oluştururken kullanılacak tip

export const tasks=pgTable("tasks",{
    id:uuid("id").primaryKey().defaultRandom(),
    title:text("title").notNull(),
    description:text("description").notNull(),
    hexColor: text("hex_color").notNull(),
    uid:uuid("uid").notNull().references(()=>users.id,{onDelete:"cascade"}),
    dueAt:timestamp("due_at").$defaultFn(()=>new Date(Date.now()+7*24*60*60*1000)),
    createdAt:timestamp("created_at").defaultNow(),
    updatedAt:timestamp("updated_at").defaultNow()
});
export type Task = typeof tasks.$inferSelect;
export type NewTask=typeof tasks.$inferInsert;
