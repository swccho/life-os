<?php

namespace App\Http\Concerns;

use Illuminate\Database\QueryException;

trait DetectsUniqueConstraintViolations
{
    protected function isUniqueConstraintViolation(QueryException $e): bool
    {
        $sqlState = (string) ($e->errorInfo[0] ?? '');

        if ($sqlState === '23000') {
            return true;
        }

        $message = $e->getMessage();

        return str_contains($message, 'Duplicate')
            || str_contains(strtolower($message), 'unique constraint');
    }
}
