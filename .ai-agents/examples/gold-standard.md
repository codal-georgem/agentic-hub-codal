# Gold-Standard Code Examples

> These examples represent the ideal patterns for this project.
> AI agents should use these as reference when generating code.
> Pseudocode is used — adapt to your project's language and framework.

---

## Example: API Endpoint

Demonstrates: input validation, authentication middleware, service delegation, consistent response envelope, error forwarding.

```
ROUTE POST /api/v1/resource
  MIDDLEWARE: authenticate, validate(inputSchema)

  FUNCTION handler(request, response, next):
    TRY:
      result = await ResourceService.create(request.body)
      response.status(201).json({ data: result })
    CATCH error:
      next(error)
```

Key patterns:

- Input validated before the handler runs
- Handler only orchestrates; business logic lives in the service layer
- Response always uses `{ data: ... }` envelope
- Errors forwarded to the centralised error handler

---

## Example: Service Layer

Demonstrates: single responsibility, typed domain errors, data access abstraction, pagination.

```
CLASS ResourceService:

  FUNCTION create(input):
    existing = db.findBy({ field: input.uniqueField })
    IF existing THEN throw ConflictError("already exists")
    RETURN db.create(input)

  FUNCTION getById(id):
    record = db.findById(id)
    IF NOT record THEN throw NotFoundError("not found")
    RETURN record

  FUNCTION list(page = 1, limit = 20):
    records = db.findMany(offset: (page - 1) * limit, limit: limit)
    total   = db.count()
    RETURN { records, total }
```

Key patterns:

- Typed domain errors (`ConflictError`, `NotFoundError`) — not generic errors
- No raw DB access outside the service layer
- Pagination on all list operations

---

## Example: UI Component

Demonstrates: container/presenter split, accessibility, error display, loading state.

```
COMPONENT ResourceForm(props: { existingRecord?, onSuccess }):

  state    = { field1: props.existingRecord?.field1 ?? "" }
  mutation = useMutation(
    fn:        existingRecord ? update(id, state) : create(state),
    onSuccess: invalidateCache + call props.onSuccess
  )

  RENDER:
    <form aria-label="Create/Edit resource">
      IF mutation.error THEN <Alert role="alert">{error.message}</Alert>
      <Input label="Field 1" value={state.field1} required aria-required />
      <Button loading={mutation.isPending}>Save</Button>
    </form>
```

Key patterns:

- Accessible form labels and ARIA attributes on every input
- Errors displayed in an accessible live region (`role="alert"`)
- Loading state on the submit button prevents double-submission
- Component is agnostic to create vs edit mode

---

## Example: Unit Test

Demonstrates: AAA pattern, typed error assertions, mock isolation.

```
describe ResourceService:

  describe create:
    it "creates a record when the unique field is not taken":
      ARRANGE: mock db.findBy → null
               mock db.create → expectedRecord
      ACT:     result = ResourceService.create(validInput)
      ASSERT:  result equals expectedRecord
               db.create called once with validInput

    it "throws ConflictError when unique field already exists":
      ARRANGE: mock db.findBy → existingRecord
      ACT/ASSERT: ResourceService.create(input) rejects with ConflictError
                  db.create NOT called

  describe getById:
    it "returns record when found":
      ARRANGE: mock db.findById → record
      ASSERT:  result equals record

    it "throws NotFoundError when record does not exist":
      ARRANGE: mock db.findById → null
      ASSERT:  rejects with NotFoundError
```

Key patterns:

- One assertion per test concept
- Mocks reset between tests
- Both happy path and typed error cases covered
- Only direct dependencies are mocked
