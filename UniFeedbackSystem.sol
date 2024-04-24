pragma solidity ^0.8.0;

contract FeedbackSystem {
    // Struct to store feedback details
    struct Feedback {
        address sender; // address of the sender (student)
        string message; // feedback message
    }

    // Mapping to store feedbacks
    mapping(uint256 => Feedback) public feedbacks;
    uint256 public feedbackCount;

    // Event to log feedback submission
    event FeedbackSubmitted(uint256 indexed id, address indexed sender, string message);

    // Modifier to restrict access to admin only
    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "Only admin can perform this action");
        _;
    }

    address public adminAddress;

    constructor() {
        adminAddress = msg.sender; // Set contract creator as admin
    }

    // Function to submit feedback
    function submitFeedback(string memory _message) public {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback(msg.sender, _message);
        emit FeedbackSubmitted(feedbackCount, msg.sender, _message);
    }

    // Function to get feedback count
    function getFeedbackCount() public view returns (uint256) {
        return feedbackCount;
    }

    // Function to get feedback details by ID
    function getFeedback(uint256 _id) public view returns (address, string memory) {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        Feedback memory feedback = feedbacks[_id];
        return (feedback.sender, feedback.message);
    }

    // Function to allow admin to retrieve all feedbacks
    function getAllFeedbacks() public view onlyAdmin returns (Feedback[] memory) {
        Feedback[] memory allFeedbacks = new Feedback[](feedbackCount);
        for (uint256 i = 1; i <= feedbackCount; i++) {
            allFeedbacks[i - 1] = feedbacks[i];
        }
        return allFeedbacks;
    }
}
