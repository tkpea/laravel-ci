<?php

namespace Tests\Feature;

use App\Article;
use App\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class ArticleTest extends TestCase
{
    // データベースをリセットするトレイト
    use RefreshDatabase;

    public function testIsLikedByBull()
    {
        $article = factory(Article::class)->create();

        $result = $article->isLikedBy(null);

        $this->assertFalse($result);
    }

    /**
     * 「いいね」しているケース
     */
    public function testIsLikedByTheUser()
    {
        /**
         * Arrange 準備
         */
        // テスト用のArticleを生成
        $article = factory(Article::class)->create();
        // テスト用のUserを生成
        $user = factory(User::class)->create();
        // テスト用UserがArticleに「いいね」する
        $article->likes()->attach($user);

        /**
         * Act 実行
         */
        $result = $article->isLikedBy($user);

        /**
         * Assert　検証
         */
        $this->assertTrue($result);
    }

    /**
     * いいねをしていないケース
     */
    public function testIsLikedByAnother()
    {
        // Arrange 準備
        $article = factory(Article::class)->create();
        // 自分Userを生成
        $user = factory(User::class)->create();
        // 他人Userを生成
        $another = factory(User::class)->create();
        // 自分ではない他人が記事にいいねする
        $article->likes()->attach($another);

        // Act 実行
        // 自分Userが記事にいいねしているかの結果を取得
        $result = $article->isLikedBy($user);

        // Assert 検証
        $this->assertFalse($result);
    }
}
