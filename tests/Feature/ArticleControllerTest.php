<?php

namespace Tests\Feature;
use App\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class ArticleControllerTest extends TestCase
{
    // データベースをリセットするトレイト
    use RefreshDatabase;

    public function testIndex()
    {
        $response = $this->get(route('articles.index')) ;

        $response->assertStatus(200)->assertViewIs('articles.index');
    }

    // ゲストユーザーがCreateにアクセスしたらログインページにリダイレクトされる
    public function testGuestCreate()
    {
        $response = $this->get(route('articles.create'));

        $response->assertRedirect(route('login'));
    }

    public function testAuthCreate()
    {
        /**
         * Arrange 準備
         * ファクトリ関数によってユーザーモデルを生成する
         */
        $user = factory(User::class)->create();

        /**
         * Act 実行
         * actingAsを利用してユーザーがログインした状態を作り出す
         */
        $response = $this->actingAs($user)->get(route('articles.create'));

        /**
         * Assert
         * リダイレクトされずにHTTPステータスコード200が返る事を確認（リダイレクトの場合は302)
         */
        $response->assertStatus(200)->assertViewIs('articles.create');
    }
}
