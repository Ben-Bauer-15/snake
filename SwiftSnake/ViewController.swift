import UIKit
import CoreData


class ViewController: UIViewController, SnakeViewDelegate {
	@IBOutlet var startButton:UIButton?
	var snakeView:SnakeView?
	var timer:Timer?
    var users = [User]()
    var currentUser = User()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var score = 0
    @IBOutlet weak var scoreLabel: UILabel!
    
    
	var snake:Snake?
	var fruit:Point?

	override func viewDidLoad() {
		super.viewDidLoad()
        scoreLabel.text = "Your score: 0"
        
        self.view.backgroundColor = UIColor.gray

        let width = self.view.frame.size.width

        //this is simply a rectangle with the origin at the bottom left corner (which is X, Y)
        let snakeFrame = CGRect(x: Int(0), y: Int(0) , width: Int(width), height: Int(width))
        
        //instantiates SnakeView with the rectangle that we just defined above
        self.snakeView = SnakeView(frame: snakeFrame)
		self.view.insertSubview(self.snakeView!, at: 0)

		if let view = self.snakeView {
			view.delegate = self
		}
        
		for direction in [UISwipeGestureRecognizerDirection.right,
			UISwipeGestureRecognizerDirection.left,
			UISwipeGestureRecognizerDirection.up,
			UISwipeGestureRecognizerDirection.down] {
				let gr = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
				gr.direction = direction
				self.view.addGestureRecognizer(gr)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func swipe (_ gr:UISwipeGestureRecognizer) {
		let direction = gr.direction
		switch direction {
		case UISwipeGestureRecognizerDirection.right:
			if (self.snake?.changeDirection(Direction.right) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.left:
			if (self.snake?.changeDirection(Direction.left) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.up:
			if (self.snake?.changeDirection(Direction.up) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.down:
			if (self.snake?.changeDirection(Direction.down) != nil) {
				self.snake?.lockDirection()
			}
		default:
			assert(false, "This could not happen")
		}
	}

	func makeNewFruit() {
		srandomdev()
		let worldSize = self.snake!.worldSize
		var x = 0, y = 0
		while (true) {
            x = Int(arc4random_uniform(UInt32(worldSize.x)))
            y = Int(arc4random_uniform(UInt32(worldSize.y)))
			var isBody = false
			for p in self.snake!.points {
				if p.x == x && p.y == y {
					isBody = true
					break
				}
			}
			if !isBody {
				break
			}
		}
		self.fruit = Point(x: x, y: y)
	}

	func startGame() {
		if (self.timer != nil) {
			return
		}

		self.startButton!.isHidden = true
        
        let width = self.view.frame.size.width
        
        //world size is the height of the frame that the snake "has access to"
        let worldSize = WorldSize(x : Int(width.truncatingRemainder(dividingBy: 100)), y : Int(width.truncatingRemainder(dividingBy: 100)) )
		self.snake = Snake(inSize: worldSize, length: 2)
		self.makeNewFruit()
		self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.timerMethod(_:)), userInfo: nil, repeats: true)
		self.snakeView!.setNeedsDisplay()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Score")
        do {
            let result = try context.fetch(request)
            print(result)
        }
        catch {
            print("\(error)")
        }
        
	}

	func endGame() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "User")
        do {
            let result = try context.fetch(request)
            users = result as! [User]
            currentUser = users[0]
        }
        catch {
            print("\(error)")
        }

        let game = NSEntityDescription.insertNewObject(forEntityName : "Score", into : context) as! Score
        game.score = Int64(score)
        game.user = currentUser
        saveContext()
        
        ScoreModel.addScore(name: delegate.name!, score: score) {
            data, response, error in
        }
        
		self.startButton!.isHidden = false
		self.timer!.invalidate()
		self.timer = nil
	}

	func timerMethod(_ timer:Timer) {
		self.snake?.move()
		let headHitBody = self.snake?.isHeadHitBody()
		if headHitBody == true {

			self.endGame()
			return
		}

		let head = self.snake?.points[0]
		if head?.x == self.fruit?.x &&
			head?.y == self.fruit?.y {
                self.score += 1
                scoreLabel.text = "Your score: " + String(self.score)
				self.snake!.increaseLength(2)
				self.makeNewFruit()
		}

		self.snake?.unlockDirection()
		self.snakeView!.setNeedsDisplay()
	}

	@IBAction func start(_ sender:AnyObject) {
		self.startGame()
	}

	func snakeForSnakeView(_ view:SnakeView) -> Snake? {
		return self.snake
	}
	func pointOfFruitForSnakeView(_ view:SnakeView) -> Point? {
		return self.fruit
	}
}
