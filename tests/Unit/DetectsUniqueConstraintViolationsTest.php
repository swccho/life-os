<?php

namespace Tests\Unit;

use App\Http\Concerns\DetectsUniqueConstraintViolations;
use Illuminate\Database\QueryException;
use PDOException;
use PHPUnit\Framework\TestCase;

class DetectsUniqueConstraintViolationsTest extends TestCase
{
    public function test_returns_true_when_sqlstate_is_23000(): void
    {
        $pdo = new PDOException('constraint', 23000);
        $pdo->errorInfo = ['23000', 1062, 'Duplicate entry'];

        $e = new QueryException('mysql', 'insert into t', [], $pdo);

        $this->assertTrue($this->detector()->check($e));
    }

    public function test_returns_true_when_message_contains_duplicate(): void
    {
        $pdo = new PDOException('Duplicate entry for key', 0);
        $pdo->errorInfo = ['HY000', 0, ''];

        $e = new QueryException('mysql', 'insert into t', [], $pdo);

        $this->assertTrue($this->detector()->check($e));
    }

    public function test_returns_true_when_message_contains_unique_constraint(): void
    {
        $pdo = new PDOException('UNIQUE constraint failed: mood_entries.user_id', 0);
        $pdo->errorInfo = ['HY000', 0, ''];

        $e = new QueryException('mysql', 'insert into t', [], $pdo);

        $this->assertTrue($this->detector()->check($e));
    }

    public function test_returns_false_for_unrelated_errors(): void
    {
        $pdo = new PDOException('syntax error', 0);
        $pdo->errorInfo = ['42000', 0, ''];

        $e = new QueryException('mysql', 'select', [], $pdo);

        $this->assertFalse($this->detector()->check($e));
    }

    private function detector(): object
    {
        return new class
        {
            use DetectsUniqueConstraintViolations;

            public function check(QueryException $e): bool
            {
                return $this->isUniqueConstraintViolation($e);
            }
        };
    }
}
