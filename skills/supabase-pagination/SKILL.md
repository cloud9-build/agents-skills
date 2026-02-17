---
name: supabase-pagination
description: Critical pattern for avoiding Supabase 1000-row limit bugs. Use when querying tables with >1000 rows or doing data comparisons.
---

# /supabase-pagination: Query Pattern Guide

## Trigger
Use this skill when:
- Working with Supabase queries on large tables (>1000 rows)
- Implementing data comparison or delta computation
- Debugging missing data or incomplete query results
- Code review flags unpaginated `.from().select()` calls

## The Problem

**Supabase `.from().select()` returns a maximum of 1000 rows by default.**

This silent limit causes:
- ❌ Incomplete data comparisons (phantom pickup bug - 63x inflation)
- ❌ Incorrect delta calculations
- ❌ Missing records in queries
- ❌ Silent failures (no error, just wrong results)

**Historical incidents:**
- Pilot test failure (1/6 matches instead of 6/6)
- Processor.ts phantom pickup bug (63x inflation)
- Validation scripts returning 0 results

---

## The Pattern: ALWAYS Use Pagination

### ❌ WRONG (Default - Returns Max 1000 Rows)

```typescript
// THIS IS BROKEN - DO NOT USE
const { data } = await supabase
  .from('fact_daily_ledger')
  .select('*')
  .eq('snapshot_date', date);

// Returns ONLY FIRST 1000 ROWS!
// Silently truncates larger datasets
```

### ✅ CORRECT (Pagination Loop)

```typescript
// THIS IS CORRECT - Gets ALL rows
async function fetchAllRows(supabase, table, filters) {
  let allData = [];
  let page = 0;
  const pageSize = 1000;

  while (true) {
    const { data, error } = await supabase
      .from(table)
      .select('*')
      .match(filters)
      .range(page * pageSize, (page + 1) * pageSize - 1);

    if (error) throw error;
    if (!data || data.length === 0) break;

    allData.push(...data);
    page++;

    if (data.length < pageSize) break; // Last page
  }

  return allData;
}

// Usage
const allLedger = await fetchAllRows(supabase, 'fact_daily_ledger', {
  snapshot_date: date
});
```

---

## When to Use This Pattern

### ALWAYS Use Pagination For:

1. **Large tables** (>1000 rows possible):
   - `fact_daily_ledger` (30,000+ rows per snapshot)
   - `fact_pickup_activity` (2,000+ rows per day)
   - Any table that grows daily

2. **Data comparisons**:
   - Comparing snapshots
   - Computing deltas
   - Finding differences

3. **Aggregations where row limit matters**:
   - Counting distinct values
   - Summing values
   - Finding max/min across full dataset

### CAN Skip Pagination For:

1. **Counts only** (use `{ count: 'exact', head: true }`):
   ```typescript
   const { count } = await supabase
     .from('fact_daily_ledger')
     .select('*', { count: 'exact', head: true })
     .eq('snapshot_date', date);
   // Returns count, not rows - no limit
   ```

2. **Single row queries** (`.single()`):
   ```typescript
   const { data } = await supabase
     .from('dim_listings')
     .select('*')
     .eq('id', listingId)
     .single();
   // Only returns 1 row by definition
   ```

3. **Small tables** (<100 rows total):
   - `dim_buildings` (10 buildings)
   - Configuration tables

---

## Helper Function (Recommended)

**File**: `lib/supabase/pagination.ts`

```typescript
/**
 * Fetch all rows from a Supabase table with automatic pagination.
 *
 * CRITICAL: Use this instead of direct .select() for tables with >1000 rows.
 *
 * @param supabase - Supabase client
 * @param table - Table name
 * @param filters - Object with filter key-value pairs
 * @param selectClause - Columns to select (default: '*')
 * @returns All rows matching filters
 */
export async function fetchAllRowsPaginated<T>(
  supabase: any,
  table: string,
  filters: Record<string, any>,
  selectClause: string = '*'
): Promise<T[]> {
  let allData: T[] = [];
  let page = 0;
  const pageSize = 1000;

  while (true) {
    const query = supabase
      .from(table)
      .select(selectClause)
      .match(filters)
      .range(page * pageSize, (page + 1) * pageSize - 1);

    const { data, error } = await query;

    if (error) {
      throw new Error(
        `Pagination query failed for ${table} page ${page}: ${error.message}`
      );
    }

    if (!data || data.length === 0) break;

    allData.push(...data);
    page++;

    // Last page reached
    if (data.length < pageSize) break;
  }

  console.log(`[Pagination] Fetched ${allData.length} rows from ${table} across ${page} pages`);

  return allData;
}
```

**Usage:**
```typescript
import { fetchAllRowsPaginated } from '@/lib/supabase/pagination';

const allLedger = await fetchAllRowsPaginated<FactDailyLedger>(
  supabase,
  'fact_daily_ledger',
  { snapshot_date: '2026-02-15' }
);

const allPickup = await fetchAllRowsPaginated<FactPickupActivity>(
  supabase,
  'fact_pickup_activity',
  { activity_date: '2026-02-16' },
  'reservation_id, pickup_orn, pickup_rev'
);
```

---

## Code Checklist

Before committing code that queries Supabase:

- [ ] Does this query a table with >1000 rows? → Use pagination
- [ ] Is this used for comparison/delta? → Use pagination
- [ ] Am I aggregating across all rows? → Use pagination or aggregation query
- [ ] Did I test with a table that has >1000 rows? → Verify pagination works
- [ ] Did I log the row count to verify completeness? → Add logging

---

## Common Violations

### Violation 1: Snapshot Queries

```typescript
// BROKEN (only gets 1000 rows)
const { data: yesterdayLedger } = await supabase
  .from('fact_daily_ledger')
  .select('*')
  .eq('snapshot_date', yesterdayDateStr);

// FIXED (gets all rows)
const yesterdayLedger = await fetchAllRowsPaginated(
  supabase,
  'fact_daily_ledger',
  { snapshot_date: yesterdayDateStr }
);
```

**Impact**: Phantom pickup bug - compares 33,000 rows against only 1,000 rows, treats 32,000 rows as "new".

### Violation 2: Test Scripts

```typescript
// BROKEN
const { data } = await supabase
  .from('fact_daily_ledger')
  .select('reservation_id')
  .eq('snapshot_date', '2026-02-14');
// Only got 1000 rows, test failed 1/6

// FIXED
const allRows = await fetchAllRowsPaginated(
  supabase,
  'fact_daily_ledger',
  { snapshot_date: '2026-02-14' }
);
```

**Impact**: Test failed with 1/6 matches instead of 6/6.

### Violation 3: Validation Queries

```typescript
// BROKEN
const { data } = await supabase
  .from('fact_pickup_activity')
  .select('*')
  .eq('activity_date', date);

// FIXED
const allPickup = await fetchAllRowsPaginated(
  supabase,
  'fact_pickup_activity',
  { activity_date: date }
);
```

---

## Testing for Pagination Bugs

### Before Merge Checklist

1. **Create test data >1000 rows**:
   ```sql
   -- Verify table has >1000 rows
   SELECT COUNT(*) FROM fact_daily_ledger WHERE snapshot_date = '2026-02-15';
   -- Should return >1000
   ```

2. **Run query and log result count**:
   ```typescript
   const result = await myQuery();
   console.log(`Query returned ${result.length} rows`);
   // Compare to expected count from SQL
   ```

3. **Verify no silent truncation**:
   - If result.length === 1000 exactly → Likely hitting limit
   - If result.length < expected → Pagination missing

---

## Quick Reference

**Problem**: Query returns fewer rows than expected

**Diagnosis**:
```typescript
// Check if hitting limit
const { data } = await supabase.from('table').select('*').eq('field', value);
if (data && data.length === 1000) {
  console.warn('⚠️ Hitting 1000-row limit!');
}
```

**Solution**: Use `fetchAllRowsPaginated()` helper function

**Prevention**: Always paginate for tables with >1000 rows

---

**Remember**: Supabase doesn't error on truncation - it silently returns 1000 rows. ALWAYS verify row counts!

## Installation

Add the helper function to your project:

```bash
# Create the helper file
mkdir -p lib/supabase
touch lib/supabase/pagination.ts

# Copy the fetchAllRowsPaginated function above into the file
```

Then import and use in your code:
```typescript
import { fetchAllRowsPaginated } from '@/lib/supabase/pagination';
```

## Related Skills

- `/build` - Use for implementing pagination fixes across codebase
- `/verify` - Use to validate pagination is working correctly
- `/retro` - Use to document lessons learned from pagination bugs
