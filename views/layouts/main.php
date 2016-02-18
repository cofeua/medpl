<?php

/* @var $this \yii\web\View */
/* @var $content string */

use yii\helpers\Html;
use yii\bootstrap\Nav;
use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use app\assets\AppAsset;

AppAsset::register($this);
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
    <meta charset="<?= Yii::$app->charset ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?= Html::csrfMetaTags() ?>
    <title><?= Html::encode($this->title) ?></title>
    <?php $this->head() ?>
</head>
<body>
<?php $this->beginBody() ?>

    <div class="top">
        <div class="wrapper">
             <?php
             echo '<div class="logo">'.Html::img('@web/images/logo.png',['alt'=>Yii::$app->name]).'</div>';
             ?>
            
        </div>
    </div>
    <div class="mainmenu">
        <div class="wrapper">
            <?php
                NavBar::begin();
                echo Nav::widget([
                    'options' => ['class' => 'navbar-nav '],
                    'items' => [
                        ['label' => 'О ДМС', 'url' => ['/site/index']],
                        ['label' => 'Простые программы', 'url' => ['/site/simple-programs']],
                        ['label' => 'Индивидуальные программы', 'url' => ['/site/privat-programs']],
                        ['label' => 'Семейные программы', 'url' => ['/site/family-programs']],
                        ['label' => 'Нестандартные условия', 'url' => ['/site/other-programs']],
                         /* Yii::$app->user->isGuest ?
                            ['label' => 'Login', 'url' => ['/site/login']] :
                            [
                                'label' => 'Logout (' . Yii::$app->user->identity->username . ')',
                                'url' => ['/site/logout'],
                                'linkOptions' => ['data-method' => 'post']
                            ],*/
                    ],
                ]);
                NavBar::end();
                ?>
            
        
        </div>    
    </div>

 <?= $content ?>
    
<footer class="footer">
    <div class="container">
        <p class="pull-left">&copy; My Company <?= date('Y') ?></p>

        <p class="pull-right"><?= Yii::powered() ?></p>
    </div>
</footer>

<?php $this->endBody() ?>
</body>
</html>
<?php $this->endPage() ?>
