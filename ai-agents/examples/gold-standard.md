# Gold-Standard Code Examples

> These examples represent the ideal code patterns for this project.
> AI agents should use these as reference when generating code.

---

## Example: API Endpoint

```typescript
import { Router, Request, Response, NextFunction } from "express";
import { z } from "zod";
import { UserService } from "@/services/user-service";
import { ApiError } from "@/errors/api-error";
import { authenticate } from "@/middleware/auth";
import { validate } from "@/middleware/validate";

const router = Router();

// Input validation schema
const createUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  role: z.enum(["admin", "member", "viewer"]),
});

/**
 * Create a new user
 * @example POST /api/v1/users { name: "Jane", email: "jane@co.com", role: "member" }
 */
router.post(
  "/users",
  authenticate,
  validate(createUserSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await UserService.create(req.body);
      res.status(201).json({ data: user });
    } catch (error) {
      next(error);
    }
  },
);

export { router as userRouter };
```

---

## Example: Service Layer

```typescript
import { db } from "@/database/client";
import { NotFoundError } from "@/errors/not-found-error";
import { ConflictError } from "@/errors/conflict-error";
import type { User, CreateUserInput } from "@/types/user";

/**
 * Handles user business logic.
 * Separates concerns from controllers and data access.
 */
export class UserService {
  /**
   * Creates a new user after checking for duplicates
   * @param input - Validated user creation data
   * @returns The created user
   * @throws ConflictError if email already exists
   *
   * @example
   * const user = await UserService.create({ name: "Jane", email: "jane@co.com", role: "member" });
   */
  static async create(input: CreateUserInput): Promise<User> {
    const existing = await db.user.findUnique({
      where: { email: input.email },
    });

    if (existing) {
      throw new ConflictError(`User with email ${input.email} already exists`);
    }

    return db.user.create({ data: input });
  }

  /**
   * Fetches a user by ID
   * @throws NotFoundError if user doesn't exist
   */
  static async getById(id: string): Promise<User> {
    const user = await db.user.findUnique({ where: { id } });

    if (!user) {
      throw new NotFoundError(`User ${id} not found`);
    }

    return user;
  }

  /**
   * Lists users with pagination
   */
  static async list(
    page = 1,
    limit = 20,
  ): Promise<{ users: User[]; total: number }> {
    const [users, total] = await Promise.all([
      db.user.findMany({
        skip: (page - 1) * limit,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      db.user.count(),
    ]);

    return { users, total };
  }
}
```

---

## Example: React Component

```tsx
import { useState, useCallback } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Alert } from "@/components/ui/alert";
import { userApi } from "@/api/user-api";
import type { User } from "@/types/user";

interface UserFormProps {
  /** Existing user data for edit mode; omit for create mode */
  user?: User;
  /** Called after successful save */
  onSuccess: () => void;
}

/**
 * Form for creating or editing a user.
 * Handles validation, submission, and error display.
 *
 * @example
 * <UserForm onSuccess={() => router.push('/users')} />
 * <UserForm user={existingUser} onSuccess={closeModal} />
 */
export function UserForm({ user, onSuccess }: UserFormProps) {
  const queryClient = useQueryClient();
  const [name, setName] = useState(user?.name ?? "");
  const [email, setEmail] = useState(user?.email ?? "");

  const mutation = useMutation({
    mutationFn: user
      ? (data: Partial<User>) => userApi.update(user.id, data)
      : (data: Partial<User>) => userApi.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
      onSuccess();
    },
  });

  const handleSubmit = useCallback(
    (e: React.FormEvent) => {
      e.preventDefault();
      mutation.mutate({ name, email });
    },
    [name, email, mutation],
  );

  return (
    <form
      onSubmit={handleSubmit}
      aria-label={user ? "Edit user" : "Create user"}
    >
      {mutation.isError && (
        <Alert variant="error" role="alert">
          {mutation.error.message}
        </Alert>
      )}

      <Input
        label="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        required
        aria-required="true"
      />

      <Input
        label="Email"
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
        aria-required="true"
      />

      <Button type="submit" loading={mutation.isPending}>
        {user ? "Save Changes" : "Create User"}
      </Button>
    </form>
  );
}
```

---

## Example: Unit Test

```typescript
import { describe, it, expect, beforeEach, vi } from "vitest";
import { UserService } from "@/services/user-service";
import { ConflictError } from "@/errors/conflict-error";
import { NotFoundError } from "@/errors/not-found-error";
import { db } from "@/database/client";

vi.mock("@/database/client");

describe("UserService", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe("create", () => {
    it("should create a user when email is unique", async () => {
      const input = {
        name: "Jane",
        email: "jane@example.com",
        role: "member" as const,
      };
      const expected = { id: "1", ...input, createdAt: new Date() };

      vi.mocked(db.user.findUnique).mockResolvedValue(null);
      vi.mocked(db.user.create).mockResolvedValue(expected);

      const result = await UserService.create(input);

      expect(result).toEqual(expected);
      expect(db.user.create).toHaveBeenCalledWith({ data: input });
    });

    it("should throw ConflictError when email already exists", async () => {
      const input = {
        name: "Jane",
        email: "existing@example.com",
        role: "member" as const,
      };
      vi.mocked(db.user.findUnique).mockResolvedValue({ id: "1" } as any);

      await expect(UserService.create(input)).rejects.toThrow(ConflictError);
      expect(db.user.create).not.toHaveBeenCalled();
    });
  });

  describe("getById", () => {
    it("should return user when found", async () => {
      const user = { id: "1", name: "Jane", email: "jane@example.com" };
      vi.mocked(db.user.findUnique).mockResolvedValue(user as any);

      const result = await UserService.getById("1");

      expect(result).toEqual(user);
    });

    it("should throw NotFoundError when user does not exist", async () => {
      vi.mocked(db.user.findUnique).mockResolvedValue(null);

      await expect(UserService.getById("missing")).rejects.toThrow(
        NotFoundError,
      );
    });
  });
});
```
