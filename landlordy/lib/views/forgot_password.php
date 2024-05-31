<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '../PHPMailer/src/Exception.php';
require '../PHPMailer/src/PHPMailer.php';
require '../PHPMailer/src/SMTP.php';

include_once ("../dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['email']) || !isset($_POST['name'])) {
        $response = array('status' => 'failed', 'message' => 'Email and name are required');
        sendJsonResponse($response);
        die();
    }

    if (isset($_POST['name']) && isset($_POST['email']) && isset($_POST['password'])) {
        $name = $_POST['name'];
        $email = $_POST['email'];
        $password = sha1($_POST['password']);
        $token = bin2hex(random_bytes(16));

        $sqlemailcheck = "SELECT * FROM `user` WHERE `user_email` = ?";
        if ($stmtEmailCheck = $conn->prepare($sqlemailcheck)) {
            $stmtEmailCheck->bind_param("s", $email);
            $stmtEmailCheck->execute();
            $stmtEmailCheck->store_result();
            if ($stmtEmailCheck->num_rows > 0) {
                $response = array('status' => 'failed', 'message' => 'Email already exists');
                sendJsonResponse($response);
                $stmtEmailCheck->close();
                die();
            }
            $stmtEmailCheck->close();
        } else {
            $response = array('status' => 'failed', 'message' => 'SQL email check preparation failed');
            sendJsonResponse($response);
            die();
        }

        $sqlinsert = "INSERT INTO `user`(`user_email`, `user_name`, `user_password`, `status`, `token`) VALUES (?, ?, ?, 'Inactive', ?)";
        if ($stmtInsert = $conn->prepare($sqlinsert)) {
            $stmtInsert->bind_param("ssss", $email, $name, $password, $token);
            if ($stmtInsert->execute()) {
                $mailResult = mailOtp($email, $name, $token);
                $response = array('status' => 'success', 'sqlInsert' => $sqlinsert, 'mailResult' => $mailResult);
            } else {
                $response = array('status' => 'failed', 'sqlInsert' => $sqlinsert, 'message' => 'SQL insert execution failed');
            }
            $stmtInsert->close();
        } else {
            $response = array('status' => 'failed', 'message' => 'SQL insert preparation failed');
        }
        sendJsonResponse($response);
    } else if (isset($_POST['email']) && isset($_POST['name'])) {
        $name = $_POST['name'];
        $email = $_POST['email'];

        $sqlcheck = "SELECT `token` FROM `user` WHERE `user_email`=? AND `status`='Inactive'";
        if ($stmtCheck = $conn->prepare($sqlcheck)) {
            $stmtCheck->bind_param("s", $email);
            $stmtCheck->execute();
            $stmtCheck->store_result();

            if ($stmtCheck->num_rows > 0) {
                $stmtCheck->bind_result($token);
                $stmtCheck->fetch();
                $mailResult = mailOtp($email, $name, $token);
                $response = array('status' => 'mail only', 'sqlCheck' => $sqlcheck, 'mailResult' => $mailResult);
            } else {
                $response = array('status' => 'failed', 'message' => 'User not found or already active');
            }
            $stmtCheck->close();
        } else {
            $response = array('status' => 'failed', 'message' => 'SQL check preparation failed');
        }
        sendJsonResponse($response);
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['email']) && isset($_GET['token'])) {
    $email = $_GET['email'];
    $token = $_GET['token'];
    $sqlverify = "UPDATE `user` SET `status`='Active', `token`=NULL WHERE `user_email`=? AND `token`=?";
    if ($stmtVerify = $conn->prepare($sqlverify)) {
        $stmtVerify->bind_param("ss", $email, $token);
        if ($stmtVerify->execute()) {
            echo "<script>alert('Your account has been verified. You can now login through the Landlordy app');window.close();</script>";
        } else {
            echo "<script>alert('Verification failed. Please check the link or contact support.');window.close();</script>";
        }
        $stmtVerify->close();
    } else {
        echo "<script>alert('SQL verification preparation failed.');window.close();</script>";
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

function mailOtp($email, $name, $token)
{
    $subject = 'Landlordy - Account Verification';
    $body = "
        <html>
        <body>
        <h4>Welcome to Landlordy</h4>
        <p>Dear <b>$name</b>,<br>
        Thank you for registering your account with Landlordy.<br>
        We are excited to have you join our community.<br>
        To complete your registration and start using our services, please verify your account by clicking the button below:<br><br>
        <a href='https://jxpersonal.com/landlordy/php/user/register_user.php?email=$email&token=$token' style='text-decoration: none;'>
        <button style='background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer;'>Verify Account</button>
        </a><br><br>
        Once your account has been verified, you can log in to Landlordy and start managing your properties with ease.<br><br>
        If you did not register for this account, please ignore this email.<br><br>
        Best regards,<br>
        The Landlordy Team
        </p>
        </body>
        </html>
        ";

    $mail = new PHPMailer(true);
    try {
        $mail->isSMTP();
        $mail->Host = 'mail.jxpersonal.com';
        $mail->SMTPAuth = true;
        $mail->Username = 'landlordy@jxpersonal.com';
        $mail->Password = 'jx011024100377';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
        $mail->Port = 465;

        $mail->setFrom('landlordy@jxpersonal.com', 'Landlordy Team');
        $mail->addAddress($email, $name);

        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body = $body;
        $mail->send();
        return "Message has been sent to $email, $name";
    } catch (Exception $e) {
        return "Message could not be sent to $email, $name. Mailer Error: {$mail->ErrorInfo}";
    }
}
?>